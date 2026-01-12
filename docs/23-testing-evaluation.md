# Testing and Evaluation

How to define success criteria and build evaluations for LLM-powered applications. These concepts apply whether you're building with Claude Code, the Agent SDK, or the API directly.

---

## Overview

Building a successful LLM application starts with clearly defining success criteria. How will you know when your application is good enough?

The prompt engineering cycle:
1. **Define success** - Establish measurable criteria
2. **Build evals** - Create test cases and grading methods
3. **Iterate** - Refine prompts based on eval results
4. **Measure** - Track improvements against baselines

Clear success criteria ensure your optimization efforts are focused on achieving specific, measurable goals.

---

## Defining Success Criteria

### SMART Criteria Framework

Good success criteria are:

| Attribute | Description | Example |
|-----------|-------------|---------|
| **Specific** | Clearly define what you want | "Accurate sentiment classification" not "good performance" |
| **Measurable** | Use quantitative metrics or defined scales | F1 score, accuracy, Likert scales |
| **Achievable** | Based on benchmarks and model capabilities | Don't expect perfection |
| **Relevant** | Aligned with application purpose and user needs | Citation accuracy matters more for medical apps |

### Good vs Bad Criteria

| Quality | Bad | Good |
|---------|-----|------|
| Vague | "Safe outputs" | "Less than 0.1% of outputs flagged for toxicity out of 10,000 trials" |
| Unmeasurable | "The model should classify sentiments well" | "F1 score of at least 0.85 on held-out test set" |
| Unrealistic | "100% accuracy on all inputs" | "5% improvement over current baseline" |

### Quantitative Metrics

**Task-specific:**
- F1 score, BLEU score, perplexity
- ROUGE scores (for summarization)
- Exact match accuracy

**Generic:**
- Accuracy, precision, recall
- Response time (ms), uptime (%)

**Measurement methods:**
- A/B testing against baseline
- User feedback (task completion rates)
- Edge case analysis (percentage handled without errors)

### Qualitative Scales

When quantitative metrics don't capture everything:

- **Likert scales**: "Rate coherence from 1 (nonsensical) to 5 (perfectly logical)"
- **Expert rubrics**: Defined criteria with examples for each score level

---

## Common Success Criteria

Most applications need multidimensional evaluation across several criteria:

### Task Fidelity

How well does the model perform on the core task? Consider:
- Standard inputs
- Edge cases (rare or challenging inputs)
- Error handling

### Consistency

How similar are responses for similar inputs? If a user asks the same question twice, should they get semantically similar answers?

### Relevance and Coherence

- Does the model directly address the question?
- Is information presented logically?
- Does it stay on topic?

### Tone and Style

- Does output style match expectations?
- Is language appropriate for the target audience?
- Is the response length appropriate?

### Privacy Preservation

- How does the model handle sensitive information?
- Can it follow instructions not to use or share certain details?
- Does it avoid leaking training data?

### Context Utilization

- How effectively does the model use provided context?
- Does it reference conversation history appropriately?
- Does it avoid hallucinating information not in context?

### Latency

What response time is acceptable? Consider:
- Real-time requirements
- User expectations
- Streaming vs complete responses

### Cost

- Cost per API call
- Token usage efficiency
- Frequency of usage

---

## Building Evals and Test Cases

### Design Principles

1. **Be task-specific**: Design evals that mirror real-world task distribution, including edge cases

2. **Automate when possible**: Structure for automated grading (multiple-choice, string match, code-graded, LLM-graded)

3. **Prioritize volume over quality**: More questions with slightly lower-signal automated grading beats fewer questions with high-quality human grading

### Edge Cases to Consider

- Irrelevant or nonexistent input data
- Overly long inputs
- Poor, harmful, or irrelevant user input (for chat use cases)
- Ambiguous cases where humans would disagree
- Adversarial inputs designed to confuse

---

## Example Evaluations

### Exact Match (Sentiment Analysis)

Best for tasks with clear-cut, categorical answers.

```python
import anthropic

tweets = [
    {"text": "This movie was a total waste of time.", "sentiment": "negative"},
    {"text": "The new album is fire! Been on repeat all day.", "sentiment": "positive"},
    {"text": "I just love it when my flight gets delayed.", "sentiment": "negative"},  # Sarcasm
    {"text": "Plot was terrible, but acting was phenomenal.", "sentiment": "mixed"},  # Mixed
]

client = anthropic.Anthropic()

def get_completion(prompt: str):
    message = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=50,
        messages=[{"role": "user", "content": prompt}]
    )
    return message.content[0].text

def evaluate_exact_match(model_output, correct_answer):
    return model_output.strip().lower() == correct_answer.lower()

outputs = [
    get_completion(f"Classify as 'positive', 'negative', 'neutral', or 'mixed': {t['text']}")
    for t in tweets
]
accuracy = sum(
    evaluate_exact_match(output, tweet['sentiment'])
    for output, tweet in zip(outputs, tweets)
) / len(tweets)

print(f"Sentiment Analysis Accuracy: {accuracy * 100}%")
```

### Cosine Similarity (Consistency)

Measures semantic similarity between responses to paraphrased questions.

```python
from sentence_transformers import SentenceTransformer
import numpy as np
import anthropic

faq_variations = [
    {
        "questions": [
            "What's your return policy?",
            "How can I return an item?",
            "Wut's yur retrn polcy?"  # Typos
        ],
        "answer": "Our return policy allows..."
    },
]

client = anthropic.Anthropic()

def get_completion(prompt: str):
    message = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=2048,
        messages=[{"role": "user", "content": prompt}]
    )
    return message.content[0].text

def evaluate_cosine_similarity(outputs):
    model = SentenceTransformer('all-MiniLM-L6-v2')
    embeddings = [model.encode(output) for output in outputs]
    cosine_similarities = np.dot(embeddings, embeddings.T) / (
        np.linalg.norm(embeddings, axis=1) * np.linalg.norm(embeddings, axis=1).T
    )
    return np.mean(cosine_similarities)

for faq in faq_variations:
    outputs = [get_completion(q) for q in faq["questions"]]
    similarity_score = evaluate_cosine_similarity(outputs)
    print(f"FAQ Consistency Score: {similarity_score * 100}%")
```

### ROUGE-L (Summarization)

Measures longest common subsequence between generated and reference summaries.

```python
from rouge import Rouge
import anthropic

articles = [
    {
        "text": "In a groundbreaking study, researchers at MIT...",
        "summary": "MIT scientists discover a new antibiotic..."
    },
]

client = anthropic.Anthropic()

def get_completion(prompt: str):
    message = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=1024,
        messages=[{"role": "user", "content": prompt}]
    )
    return message.content[0].text

def evaluate_rouge_l(model_output, true_summary):
    rouge = Rouge()
    scores = rouge.get_scores(model_output, true_summary)
    return scores[0]['rouge-l']['f']  # ROUGE-L F1 score

outputs = [
    get_completion(f"Summarize in 1-2 sentences:\n\n{a['text']}")
    for a in articles
]
scores = [
    evaluate_rouge_l(output, article['summary'])
    for output, article in zip(outputs, articles)
]
print(f"Average ROUGE-L F1 Score: {sum(scores) / len(scores)}")
```

### LLM-Based Likert Scale (Tone)

Uses an LLM to rate subjective qualities on a defined scale.

```python
import anthropic

inquiries = [
    {"text": "This is the third time you've messed up my order!", "tone": "empathetic"},
    {"text": "I tried resetting my password but my account got locked", "tone": "patient"},
]

client = anthropic.Anthropic()

def get_completion(prompt: str):
    message = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=2048,
        messages=[{"role": "user", "content": prompt}]
    )
    return message.content[0].text

def evaluate_likert(model_output, target_tone):
    tone_prompt = f"""Rate this customer service response on a scale of 1-5 for being {target_tone}:
    <response>{model_output}</response>
    1: Not at all {target_tone}
    5: Perfectly {target_tone}
    Output only the number."""

    # Best practice: use different model for evaluation
    response = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=50,
        messages=[{"role": "user", "content": tone_prompt}]
    )
    return int(response.content[0].text.strip())

outputs = [
    get_completion(f"Respond to this customer inquiry: {i['text']}")
    for i in inquiries
]
scores = [
    evaluate_likert(output, inquiry['tone'])
    for output, inquiry in zip(outputs, inquiries)
]
print(f"Average Tone Score: {sum(scores) / len(scores)}")
```

### LLM-Based Binary Classification (Privacy)

Classifies whether a response contains sensitive information.

```python
import anthropic

patient_queries = [
    {"query": "What are the side effects of Lisinopril?", "contains_phi": False},
    {"query": "Why was John Doe, DOB 5/12/1980, prescribed Metformin?", "contains_phi": True},
]

client = anthropic.Anthropic()

def get_completion(prompt: str):
    message = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=1024,
        messages=[{"role": "user", "content": prompt}]
    )
    return message.content[0].text

def evaluate_binary(model_output, query_contains_phi):
    if not query_contains_phi:
        return True

    binary_prompt = f"""Does this response contain Personal Health Information (PHI)?
    PHI includes: names, addresses, birthdates, medical record numbers,
    diagnoses, treatment plans, test results, medication records.

    <response>{model_output}</response>
    Output only 'yes' or 'no'."""

    response = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=50,
        messages=[{"role": "user", "content": binary_prompt}]
    )
    return response.content[0].text.strip().lower() == "no"

system = """You are a medical assistant. Never reveal any PHI in responses.
PHI includes individually identifiable health data."""

outputs = [
    get_completion(f"{system}\n\nQuestion: {q['query']}")
    for q in patient_queries
]
scores = [
    evaluate_binary(output, q['contains_phi'])
    for output, q in zip(outputs, patient_queries)
]
print(f"Privacy Preservation Score: {sum(scores) / len(scores) * 100}%")
```

### LLM-Based Ordinal Scale (Context Utilization)

Measures how well the model uses conversation history.

```python
import anthropic

conversations = [
    [
        {"role": "user", "content": "I just got a new pomeranian!"},
        {"role": "assistant", "content": "Congratulations! Is this your first dog?"},
        {"role": "user", "content": "Yes, I named her Luna."},
        {"role": "assistant", "content": "Luna is a lovely name! What would you like to know?"},
        {"role": "user", "content": "What should I know about caring for this breed?"}
    ],
]

client = anthropic.Anthropic()

def get_completion(messages):
    response = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=1024,
        messages=messages
    )
    return response.content[0].text

def evaluate_ordinal(model_output, conversation):
    context = "\n".join(f"{m['role']}: {m['content']}" for m in conversation[:-1])
    ordinal_prompt = f"""Rate how well this response utilizes conversation context (1-5):
    <conversation>
    {context}
    </conversation>
    <response>{model_output}</response>
    1: Completely ignores context
    5: Perfectly utilizes context
    Output only the number."""

    response = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=50,
        messages=[{"role": "user", "content": ordinal_prompt}]
    )
    return int(response.content[0].text.strip())

outputs = [get_completion(conv) for conv in conversations]
scores = [
    evaluate_ordinal(output, conv)
    for output, conv in zip(outputs, conversations)
]
print(f"Average Context Utilization Score: {sum(scores) / len(scores)}")
```

> **Tip:** Get Claude to help generate more test cases from a baseline set of examples.

---

## Grading Methods

Choose the fastest, most reliable, most scalable method:

### 1. Code-Based Grading

**Fastest and most reliable.** Use when possible.

```python
# Exact match
def grade_exact(output, expected):
    return output == expected

# String match
def grade_contains(output, key_phrase):
    return key_phrase in output

# Regex match
import re
def grade_pattern(output, pattern):
    return bool(re.search(pattern, output))
```

**Best for:** Classification, extraction, structured outputs

### 2. Human Grading

**Most flexible but slow and expensive.** Avoid if possible.

**Use when:**
- Establishing ground truth for LLM grader calibration
- Evaluating highly subjective or nuanced outputs
- Final quality checks on small sample sets

### 3. LLM-Based Grading

**Fast, flexible, and scalable.** Test reliability first, then scale.

```python
def build_grader_prompt(answer, rubric):
    return f"""Grade this answer based on the rubric:
    <rubric>{rubric}</rubric>
    <answer>{answer}</answer>
    Think through your reasoning in <thinking> tags, then output 'correct' or 'incorrect' in <result> tags."""

def grade_completion(output, golden_answer):
    grader_response = client.messages.create(
        model="claude-sonnet-4-5",
        max_tokens=2048,
        messages=[{"role": "user", "content": build_grader_prompt(output, golden_answer)}]
    ).content[0].text

    return "correct" if "correct" in grader_response.lower() else "incorrect"
```

### Tips for LLM-Based Grading

1. **Detailed rubrics**: "The answer should always mention 'Acme Inc.' in the first sentence. If not, grade as 'incorrect.'"

2. **Empirical outputs**: Instruct the LLM to output only 'correct'/'incorrect' or a numeric score (1-5)

3. **Encourage reasoning**: Ask the LLM to think before scoring, then extract just the score. This improves evaluation quality.

4. **Use different models**: Best practice is to use a different model for evaluation than the one being evaluated

---

## Applying to Claude Code Projects

### Using Hooks for Automated Testing

Create a PostToolUse hook to validate outputs:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "command": "python scripts/validate_output.py"
      }
    ]
  }
}
```

### Test Suites in Skills

Create a testing skill that runs evals:

```markdown
---
name: run-evals
description: Run evaluation suite against current implementation
---

Run the evaluation suite in `tests/evals/` and report results.
Focus on any regressions from the baseline scores.
```

### Validation in CLAUDE.md

Add success criteria to your project memory:

```markdown
## Quality Standards

Before marking a task complete, verify:
- All unit tests pass
- Response latency < 200ms for API endpoints
- No PII in generated outputs
- Error messages are user-friendly
```

### Iterative Improvement Workflow

1. Define success criteria in CLAUDE.md
2. Create baseline eval set
3. Measure current performance
4. Make changes
5. Re-run evals
6. Compare against baseline
7. Document improvements in commit messages

---

## See Also

- [21-prompt-engineering.md](./21-prompt-engineering.md) - Prompting techniques to improve eval scores
- [02-hooks.md](./02-hooks.md) - Automated validation with hooks
- [03-skills.md](./03-skills.md) - Creating testing skills
- [20-agent-sdk.md](./20-agent-sdk.md) - Programmatic testing with the SDK
