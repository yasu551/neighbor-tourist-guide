import { Controller } from "@hotwired/stimulus"
import OpenAI from "openai";

// Connects to data-controller="chat-completion"
export default class extends Controller {
  static targets = ['inputText', 'outputText'];
  static values = { apiKey: String };

  initialize() {
    this.openai = new OpenAI({ apiKey: this.apiKeyValue, dangerouslyAllowBrowser: true });
  }

  async replaceDescription() {
    const completion = await this.openai.chat.completions.create({
      messages: [
        { role: "system", content: "assistantは旅行ガイドであり、userは旅行者です。assistantはmarkdown記法を使わず、話し言葉のような文章を返します。" },
        { role: 'assistant', content: "了解しました！どの国または都市についての情報をお知りになりたいですか？また、どのようなアクティビティに興味がありますか？例えば、文化的な観光、食事、自然の探索などがあります。" },
        { role: 'user', content: `${this.inputTextTarget.innerText}について説明してください。` },
      ],
      model: "gpt-4o",
    });
    const description = completion.choices[0]['message']['content'];
    this.outputTextTarget.innerText = description;
  }
}
