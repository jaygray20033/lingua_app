const axios = require('axios');

const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
const OPENROUTER_BASE_URL = process.env.OPENROUTER_BASE_URL || 'https://openrouter.ai/api/v1';
const AI_MODEL = process.env.AI_MODEL || 'openai/gpt-4o';

const callOpenRouter = async (messages, options = {}) => {
  const response = await axios.post(
    `${OPENROUTER_BASE_URL}/chat/completions`,
    {
      model: options.model || AI_MODEL,
      messages,
      temperature: options.temperature || 0.7,
      max_tokens: options.maxTokens || 500,
      stream: options.stream || false
    },
    {
      headers: {
        'Authorization': `Bearer ${OPENROUTER_API_KEY}`,
        'HTTP-Referer': 'https://lingua-app.com',
        'X-Title': 'Lingua Language Learning',
        'Content-Type': 'application/json'
      },
      responseType: options.stream ? 'stream' : 'json',
      timeout: 30000
    }
  );
  return response;
};

/**
 * Explain a grammar point or wrong answer
 */
const explainGrammar = async (text, context = '', targetLang = 'ja') => {
  const langNames = { ja: 'tiếng Nhật', en: 'tiếng Anh', zh: 'tiếng Trung', ko: 'tiếng Hàn' };
  const langName = langNames[targetLang] || 'ngoại ngữ';

  const messages = [
    {
      role: 'system',
      content: `Bạn là gia sư ngôn ngữ AI chuyên về ${langName}. 
Giải thích ngắn gọn, dùng ví dụ cụ thể, phù hợp người Việt học. 
Luôn trả lời bằng tiếng Việt. Dùng format rõ ràng với:
- 📝 Giải thích
- 💡 Ví dụ
- ⚠️ Lưu ý (nếu có)`
    },
    {
      role: 'user',
      content: context
        ? `Giải thích câu/từ này: "${text}"\nNgữ cảnh: ${context}`
        : `Giải thích câu/từ này: "${text}"`
    }
  ];

  const response = await callOpenRouter(messages, { maxTokens: 600 });
  const content = response.data.choices[0].message.content;
  const tokensUsed = response.data.usage?.total_tokens || 0;

  return { explanation: content, tokensUsed };
};

/**
 * AI Roleplay conversation - returns SSE stream
 */
const chatRoleplayStream = async (res, { scenario, messages, language = 'ja' }) => {
  const systemPrompt = scenario
    ? `${scenario.context_prompt}\n\nMục tiêu hội thoại: ${scenario.goal}\nNgôn ngữ: ${language === 'ja' ? '日本語' : language === 'zh' ? '中文' : language === 'ko' ? '한국어' : 'English'}\nHãy duy trì nhân vật, sửa lỗi nhẹ nhàng và khuyến khích user.`
    : `Bạn là giáo viên ${language} thân thiện. Luyện hội thoại với user bằng ${language}. Sửa lỗi nhẹ nhàng.`;

  const fullMessages = [
    { role: 'system', content: systemPrompt },
    ...messages.map(m => ({ role: m.role === 'AI' ? 'assistant' : 'user', content: m.content }))
  ];

  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.flushHeaders();

  try {
    const response = await callOpenRouter(fullMessages, {
      stream: true,
      maxTokens: 400,
      temperature: 0.8
    });

    let fullContent = '';
    response.data.on('data', (chunk) => {
      const lines = chunk.toString().split('\n');
      lines.forEach(line => {
        if (line.startsWith('data: ') && line !== 'data: [DONE]') {
          try {
            const data = JSON.parse(line.slice(6));
            const content = data.choices?.[0]?.delta?.content;
            if (content) {
              fullContent += content;
              res.write(`data: ${JSON.stringify({ content })}\n\n`);
            }
          } catch (e) {}
        }
      });
    });

    response.data.on('end', () => {
      res.write(`data: ${JSON.stringify({ done: true, fullContent })}\n\n`);
      res.end();
    });

    response.data.on('error', (err) => {
      res.write(`data: ${JSON.stringify({ error: err.message })}\n\n`);
      res.end();
    });
  } catch (err) {
    res.write(`data: ${JSON.stringify({ error: 'Lỗi kết nối AI' })}\n\n`);
    res.end();
  }
};

/**
 * Explain a wrong answer in an exercise
 */
const explainAnswer = async (exercise, userAnswer, correctAnswer, language = 'ja') => {
  const messages = [
    {
      role: 'system',
      content: `Bạn là gia sư ngôn ngữ AI. Giải thích tại sao đáp án đúng bằng tiếng Việt. Ngắn gọn, dễ hiểu.`
    },
    {
      role: 'user',
      content: `Bài tập: "${exercise}"
User trả lời: "${userAnswer}"  
Đáp án đúng: "${correctAnswer}"
Tại sao đáp án đúng? Quy tắc ngữ pháp gì?`
    }
  ];

  const response = await callOpenRouter(messages, { maxTokens: 400 });
  return {
    explanation: response.data.choices[0].message.content,
    tokensUsed: response.data.usage?.total_tokens || 0
  };
};

/**
 * Generate AI Study Plan
 */
const generateStudyPlan = async ({ language, level, dailyMinutes, targetDate, weakPoints = [] }) => {
  const messages = [
    {
      role: 'system',
      content: `Bạn là chuyên gia lập kế hoạch học ngôn ngữ. Tạo lịch học chi tiết theo tuần bằng tiếng Việt. Format JSON.`
    },
    {
      role: 'user',
      content: `Tạo kế hoạch học ${language}:
- Level hiện tại: ${level}
- Thời gian mỗi ngày: ${dailyMinutes} phút
- Ngày thi mục tiêu: ${targetDate || 'Không cố định'}
- Điểm yếu: ${weakPoints.join(', ') || 'Chưa xác định'}

Trả về JSON với format: {"weeklyPlan": [{"week": 1, "focus": "...", "dailyTasks": [...]}]}`
    }
  ];

  const response = await callOpenRouter(messages, { maxTokens: 1000, temperature: 0.5 });
  try {
    const text = response.data.choices[0].message.content;
    const jsonMatch = text.match(/\{[\s\S]*\}/);
    return jsonMatch ? JSON.parse(jsonMatch[0]) : { weeklyPlan: [], raw: text };
  } catch {
    return { weeklyPlan: [], raw: response.data.choices[0].message.content };
  }
};

module.exports = { explainGrammar, chatRoleplayStream, explainAnswer, generateStudyPlan };
