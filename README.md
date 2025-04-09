# Action Chat Translator

A real-time conversation translator via Slack using a free LLM (OpenRouter), with a lightweight web interface and architecture following SOLID principles.

---

## Features

- Integrates with Slack via the Events API
- Automatically translates messages to Portuguese (via LLM)
- Slack-style web interface with manual response confirmation
- Sends translated replies back to the original Slack channel
- 100% Ruby backend (no Rails)
- Full test coverage with RSpec
- Minimal frontend using pure HTML, CSS, and JavaScript
- Easy deployment via Cloudflare Tunnel

---

## Requirements

- Ruby 2.6+ (without Rails)
- WEBrick Web Server
- PostgreSQL
- Docker (optional for local LLM)
- Account on [OpenRouter.ai](https://openrouter.ai)
- Account on [Slack API](https://api.slack.com/apps)

---

## Setup

```bash
git clone https://github.com/bandeirabeto/action_chat_translator.git
cd action_chat_translator
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
ruby bin/start.rb
```
