import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mongo_ai/create/domain/model/prompt.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response_content.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response_output.dart';

part 'create_template_params.freezed.dart';

@freezed
abstract class CreateTemplateParams with _$CreateTemplateParams {
  const factory CreateTemplateParams({
    // 만약, 유형을 하나만 선택할시,
    // 클린 텍스트 리스트 제외하고,
    // 각 리스트에는 데이터가 하나씩만 들어갑니다.
    required List<String> cleanText, // 클린 텍스트 리스트
    required List<OpenAiResponse> response, // Open AI 응답 리스트
    required List<Prompt> prompt, // 프롬프트 리스트
  }) = _CreateTemplateParams;

  factory CreateTemplateParams.sampleData() {
    return const CreateTemplateParams(
      cleanText: [
        'One way to avoid contributing to overhyping a story would be to say nothing. However, that is not a realistic option for scientists who feel a strong sense of responsibility to inform the public and policymakers and/or to offer suggestions. Speaking with members of the media has advantages in getting a message out and perhaps receiving favorable recognition, but it runs the risk of misinterpretations, the need for repeated clarifications, and engagement in never-ending controversy. Hence, the decision of whether to speak with the media tends to be highly individualized. Decades ago, it was unusual for Earth scientists to have results that were of interest to the media, and consequently few media contacts were expected or encouraged. In the 1970s, the few scientists who spoke frequently with the media were often criticized by their fellow scientists for having done so. The situation now is quite different, as many scientists feel a responsibility to speak out because of the importance of global warming and related issues, and many reporters share these feelings. In addition, many scientists are finding that they enjoy the media attention and the public recognition that comes with it. At the same time, other scientists continue to resist speaking with reporters, thereby preserving more time for their science and avoiding the risk of being misquoted and the other unpleasantries associated with media coverage.',
        'We trust our common sense largely because we are prone to naive realism: the belief that we see the world precisely as it is. We assume that “seeing is believing” and trust our intuitive perceptions of the world and ourselves. In daily life, naive realism often serves us well. If you are driving down a one-lane road and see a tractor-trailer moving uncontrollably toward you at 120 kilometers per hour, it is a wise idea to get out of the way. Much of the time, we should trust our perceptions. Yet appearances can sometimes be deceiving. The Earth seems flat. The sun seems to revolve around the Earth. Yet in both cases, our intuitions are wrong. Sometimes, what appears to be obvious can mislead us when it comes to evaluating ourselves and others. Our common sense tells us that memories accurately capture virtually everything we have seen, although scientific research demonstrates otherwise. Our common sense also assures us that people who do not share our political views are biased, but that we are objective. Yet psychological research demonstrates that we are all susceptible to evaluating political issues in a biased fashion. So our tendencies to believe appearances can lead us to draw erroneous conclusions about human nature. In many cases, “believing is seeing” rather than the reverse: our beliefs shape our perceptions of the world.',
        'Some people claim that gratitude is just about thinking nice thoughts and expecting good things — and ignores the negativity, pain, and suffering in life. Well, they’re wrong. Consider our definition of gratitude, as a specific way of thinking about receiving a benefit and giving credit to others besides yourself for that benefit. In fact, gratitude can be very difficult, because it requires that you recognize your dependence on others, and that’s not always positive. You have to humble yourself, in the sense that you have to become a good receiver of other people’s help or generosity. That can be very hard — most people are better givers than receivers. What’s more, feelings of gratitude can sometimes get tied up with related feelings — like indebtedness and obligation, which doesn’t sound like positive thinking at all. If I am grateful for something provided to me, I have to take care of that thing — I might even have to reciprocate at some appropriate time in the future. That type of indebtedness or obligation can be perceived very negatively — it can cause people real discomfort, as Jill Suttie explores in her essay “How to Say Thanks Without Feeling Indebted.” The data bear this out. When people are grateful, they aren’t necessarily free of negative emotions — we don’t find that they necessarily have less anxiety or less tension or less unhappiness. Practicing gratitude magnifies positive feelings more than it reduces negative feelings. If gratitude were just positive thinking, or a form of denial, you’d experience no negative thoughts or feelings when you’re keeping a gratitude journal, for instance. But, in fact, people do.',
        'In all social systems, it is true that people’s behavior is influenced by social rules and they are extraordinarily adaptable. One natural experiment involving baboons is instructive. A study in 2004 examined how a troop of wild baboons changed after large and aggressive males changed after all those dominant males caught a disease and died, leaving the gentler males remaining. The social order was characterized by greatly reduced bullying and aggression, and it persisted as males joined the group. Conflict was still the norm, but the fighting did not escalate as with peaceful outcomes, and the high tolerance of the original males, who had survived, was taught to the newcomers. The researchers concluded that the troop’s culture had changed. But what about humans? The answer is that humans are even more adaptable, and their behavioral norms are even more variable. Obviously, humans are not baboons. But it seems highly possible that this is basically similar to why different human societies can have much different behavioral norms — consider premodern tribes who worshiped their ancestors and shared food in common, medieval peasants who accepted the divine right of kings and performed free labor for feudal lords, and people today who believe in democracy and corporate employment contracts. Human societies have much more complexity and choice than baboon societies, but the point is that behavioral norms are to a great degree the product of culture and learning, not the other way around.',
      ],
      response: [
        OpenAiResponse(
          id: 'resp_6826e0cb95e48198b5433139cdc85d2a0a4e531813533243',
          status: "completed",
          error: null,
          instructions:
              '''아래 영어 지문을 “지문”으로 먼저 제시한 뒤, 빈칸 문제 1개를 실제 시험지처럼 만들어 주세요.
• 핵심 어휘 하나를 ‘_____’으로 대체
• 문장은 영어로 작성
• 객관식 형태로 문제를 출력할 것.(예시 : 1,2,3,4)
• 해설은 제외
• 문제는 한국어로 작성할 것.
• 정답은 표시하지 않아도 됨.
• 지문,문제 앞에 붙는 '#'은 반드시 넣어줄 것

# 1번 지문: {지문}

# 빈칸 1번 문제:
{생성된 문제}
A. ...
B. ...
C. ...
D. ...s

"~^^~" 가 있다면 다른 지문(문제)으로 인식하고, 각 지문(문제) 별로 아래와 같이 정리해줘. 그리고 각 문제마다 이전과 똑같이 "~^^~"로 구분해줘.''',
          output: [
            OpenAIResponseOutput(
              id: 'msg_6826e0cc347c8198ac9bfa7b826c79e20a4e531813533243',
              type: 'message',
              status: 'completed',
              content: [
                OpenAIResponseContent(
                  type: 'output_text',
                  annotations: [],
                  text:
                      '''# 1번 지문: One way to avoid contributing to overhyping a story would be to say nothing. However, that is not a realistic option for scientists who feel a strong sense of responsibility to inform the public and policymakers and/or to offer suggestions. Speaking with members of the media has advantages in getting a message out and perhaps receiving favorable ____, but it runs the risk of misinterpretations, the need for repeated clarifications, and engagement in never-ending controversy. Hence, the decision of whether to speak with the media tends to be highly individualized. Decades ago, it was unusual for Earth scientists to have results that were of interest to the media, and consequently few media contacts were expected or encouraged. In the 1970s, the few scientists who spoke frequently with the media were often criticized by their fellow scientists for having done so. The situation now is quite different, as many scientists feel a responsibility to speak out because of the importance of global warming and related issues, and many reporters share these feelings. In addition, many scientists are finding that they enjoy the media attention and the public recognition that comes with it. At the same time, other scientists continue to resist speaking with reporters, thereby preserving more time for their science and avoiding the risk of being misquoted and the other unpleasantries associated with media coverage.

# 빈칸 1번 문제:
다음 빈칸에 들어갈 가장 알맞은 단어를 고르세요.
A. recognition  
B. experiment  
C. hesitation  
D. prediction  

~^^~
# 2번 지문: We trust our common sense largely because we are prone to naive _____: the belief that we see the world precisely as it is. We assume that “seeing is believing” and trust our intuitive perceptions of the world and ourselves. In daily life, naive realism often serves us well. If you are driving down a one-lane road and see a tractor-trailer moving uncontrollably toward you at 120 kilometers per hour, it is a wise idea to get out of the way. Much of the time, we should trust our perceptions. Yet appearances can sometimes be deceiving. The Earth seems flat. The sun seems to revolve around the Earth. Yet in both cases, our intuitions are wrong. Sometimes, what appears to be obvious can mislead us when it comes to evaluating ourselves and others. Our common sense tells us that memories accurately capture virtually everything we have seen, although scientific research demonstrates otherwise. Our common sense also assures us that people who do not share our political views are biased, but that we are objective. Yet psychological research demonstrates that we are all susceptible to evaluating political issues in a biased fashion. So our tendencies to believe appearances can lead us to draw erroneous conclusions about human nature. In many cases, “believing is seeing” rather than the reverse: our beliefs shape our perceptions of the world.

# 빈칸 1번 문제:
다음 빈칸에 들어갈 가장 알맞은 단어를 고르세요.
A. realism  
B. optimism  
C. criticism  
D. ambition  

~^^~
# 3번 지문: Some people claim that gratitude is just about thinking nice thoughts and expecting good things — and ignores the negativity, pain, and suffering in life. Well, they’re wrong. Consider our definition of gratitude, as a specific way of thinking about receiving a benefit and giving credit to others besides yourself for that benefit. In fact, gratitude can be very difficult, because it requires that you recognize your _____ on others, and that’s not always positive. You have to humble yourself, in the sense that you have to become a good receiver of other people’s help or generosity. That can be very hard — most people are better givers than receivers. What’s more, feelings of gratitude can sometimes get tied up with related feelings — like indebtedness and obligation, which doesn’t sound like positive thinking at all. If I am grateful for something provided to me, I have to take care of that thing — I might even have to reciprocate at some appropriate time in the future. That type of indebtedness or obligation can be perceived very negatively — it can cause people real discomfort, as Jill Suttie explores in her essay “How to Say Thanks Without Feeling Indebted.” The data bear this out. When people are grateful, they aren’t necessarily free of negative emotions — we don’t find that they necessarily have less anxiety or less tension or less unhappiness. Practicing gratitude magnifies positive feelings more than it reduces negative feelings. If gratitude were just positive thinking, or a form of denial, you’d experience no negative thoughts or feelings when you’re keeping a gratitude journal, for instance. But, in fact, people do.

# 빈칸 1번 문제:
다음 빈칸에 들어갈 가장 알맞은 단어를 고르세요.
A. dependence  
B. influence  
C. curiosity  
D. authority  

~^^~
# 4번 지문: In all social systems, it is true that people’s behavior is influenced by social rules and they are extraordinarily adaptable. One natural experiment involving baboons is instructive. A study in 2004 examined how a troop of wild baboons changed after large and aggressive males changed after all those dominant males caught a disease and died, leaving the gentler males remaining. The new social order was characterized by greatly reduced bullying and aggression, and it persisted as new males joined the group. Conflict was still the norm, but the fighting did not escalate as with peaceful outcomes, and the high tolerance of the original males, who had survived, was taught to the newcomers. The researchers concluded that the troop’s culture had changed. But what about humans? The answer is that humans are even more adaptable, and their behavioral norms are even more variable. Obviously, humans are not baboons. But it seems highly possible that this is basically similar to why different human societies can have much different behavioral norms — consider premodern tribes who worshiped their ______ and shared food in common, medieval peasants who accepted the divine right of kings and performed free labor for feudal lords, and people today who believe in democracy and corporate employment contracts. Human societies have much more complexity and choice than baboon societies, but the point is that behavioral norms are to a great degree the product of culture and _____, not the other way around.

# 빈칸 1번 문제:
다음 빈칸에 들어갈 가장 알맞은 단어를 고르세요.
A. learning  
B. instinct  
C. heredity  
D. tradition  

~^^~''',
                ),
              ],
              role: 'assistant',
            ),
          ],
        ),
        OpenAiResponse(
          id: 'resp_6826e0da75e48198b345afcfd18e9ed1056dfbc41dce9524',
          status: 'completed',
          error: null,
          instructions:
              '''아래 영어 지문을 “지문”으로 먼저 제시한 뒤, 객관식 문제 1개를 실제 시험지처럼 만들어 주세요.
• 보기 A~D, 문항과 보기는 영어로 작성
• 해설은 제외
• 문제는 한국어로 작성할 것.
• 정답은 표시하지 않아도 됨.
• 지문,문제 앞에 붙는 '#'은 반드시 넣어줄 것

# 1번 지문: {지문}

# 객관식 1번 문제:
{생성된 문제}
A. ...
B. ...
C. ...
D. ...

"~^^~" 가 있다면 다른 지문(문제)으로 인식하고, 각 지문(문제) 별로 아래와 같이 정리해줘. 그리고 각 문제마다 이전과 똑같이 "~^^~"로 구분해줘.''',
          output: [
            OpenAIResponseOutput(
              id: 'msg_6826e0daf19c8198bf27cddef35463da056dfbc41dce9524',
              type: 'message',
              status: 'completed',
              content: [
                OpenAIResponseContent(
                  type: 'output_text',
                  annotations: [],
                  text: '''# 1번 지문: 
One way to avoid contributing to overhyping a story would be to say nothing. However, that is not a realistic option for scientists who feel a strong sense of responsibility to inform the public and policymakers and/or to offer suggestions. Speaking with members of the media has advantages in getting a message out and perhaps receiving favorable recognition, but it runs the risk of misinterpretations, the need for repeated clarifications, and engagement in never-ending controversy. Hence, the decision of whether to speak with the media tends to be highly individualized. Decades ago, it was unusual for Earth scientists to have results that were of interest to the media, and consequently few media contacts were expected or encouraged. In the 1970s, the few scientists who spoke frequently with the media were often criticized by their fellow scientists for having done so. The situation now is quite different, as many scientists feel a responsibility to speak out because of the importance of global warming and related issues, and many reporters share these feelings. In addition, many scientists are finding that they enjoy the media attention and the public recognition that comes with it. At the same time, other scientists continue to resist speaking with reporters, thereby preserving more time for their science and avoiding the risk of being misquoted and the other unpleasantries associated with media coverage.

# 객관식 1번 문제:
과학자들이 언론과 소통할 때 겪을 수 있는 어려움으로 언급되지 않은 것은 무엇입니까?
A. Risk of being misquoted
B. Receiving favorable recognition
C. Engagement in never-ending controversy
D. Need for repeated clarifications

~^^~

# 2번 지문: 
We trust our common sense largely because we are prone to naive realism: the belief that we see the world precisely as it is. We assume that “seeing is believing” and trust our intuitive perceptions of the world and ourselves. In daily life, naive realism often serves us well. If you are driving down a one-lane road and see a tractor-trailer moving uncontrollably toward you at 120 kilometers per hour, it is a wise idea to get out of the way. Much of the time, we should trust our perceptions. Yet appearances can sometimes be deceiving. The Earth seems flat. The sun seems to revolve around the Earth. Yet in both cases, our intuitions are wrong. Sometimes, what appears to be obvious can mislead us when it comes to evaluating ourselves and others. Our common sense tells us that memories accurately capture virtually everything we have seen, although scientific research demonstrates otherwise. Our common sense also assures us that people who do not share our political views are biased, but that we are objective. Yet psychological research demonstrates that we are all susceptible to evaluating political issues in a biased fashion. So our tendencies to believe appearances can lead us to draw erroneous conclusions about human nature. In many cases, “believing is seeing” rather than the reverse: our beliefs shape our perceptions of the world.

# 객관식 1번 문제:
지문에 따르면, 우리의 상식이 잘못된 결론을 내리게 할 수 있는 이유는 무엇입니까?
A. We always rely on scientific research
B. Our beliefs can shape our perceptions
C. We never trust our perceptions
D. Our memories are always accurate

~^^~

# 3번 지문: 
Some people claim that gratitude is just about thinking nice thoughts and expecting good things — and ignores the negativity, pain, and suffering in life. Well, they’re wrong. Consider our definition of gratitude, as a specific way of thinking about receiving a benefit and giving credit to others besides yourself for that benefit. In fact, gratitude can be very difficult, because it requires that you recognize your dependence on others, and that’s not always positive. You have to humble yourself, in the sense that you have to become a good receiver of other people’s help or generosity. That can be very hard — most people are better givers than receivers. What’s more, feelings of gratitude can sometimes get tied up with related feelings — like indebtedness and obligation, which doesn’t sound like positive thinking at all. If I am grateful for something provided to me, I have to take care of that thing — I might even have to reciprocate at some appropriate time in the future. That type of indebtedness or obligation can be perceived very negatively — it can cause people real discomfort, as Jill Suttie explores in her essay “How to Say Thanks Without Feeling Indebted.” The data bear this out. When people are grateful, they aren’t necessarily free of negative emotions — we don’t find that they necessarily have less anxiety or less tension or less unhappiness. Practicing gratitude magnifies positive feelings more than it reduces negative feelings. If gratitude were just positive thinking, or a form of denial, you’d experience no negative thoughts or feelings when you’re keeping a gratitude journal, for instance. But, in fact, people do.

# 객관식 1번 문제:
감사(Gratitude)에 대한 설명으로 옳지 않은 것은 무엇입니까?
A. Gratitude always eliminates negative emotions
B. Gratitude can involve feelings of obligation
C. Practicing gratitude increases positive feelings
D. Being grateful may require humility

~^^~

# 4번 지문: 
In all social systems, it is true that people’s behavior is influenced by social rules and they are extraordinarily adaptable. One natural experiment involving baboons is instructive. A study in 2004 examined how a troop of wild baboons changed after large and aggressive males changed after all those dominant males caught a disease and died, leaving the gentler males remaining. The new social order was characterized by greatly reduced bullying and aggression, and it persisted as new males joined the group. Conflict was still the norm, but the fighting did not escalate as with peaceful outcomes, and the high tolerance of the original males, who had survived, was taught to the newcomers. The researchers concluded that the troop’s culture had changed. But what about humans? The answer is that humans are even more adaptable, and their behavioral norms are even more variable. Obviously, humans are not baboons. But it seems highly possible that this is basically similar to why different human societies can have much different behavioral norms — consider premodern tribes who worshiped their ancestors and shared food in common, medieval peasants who accepted the divine right of kings and performed free labor for feudal lords, and people today who believe in democracy and corporate employment contracts. Human societies have much more complexity and choice than baboon societies, but the point is that behavioral norms are to a great degree the product of culture and learning, not the other way around.

# 객관식 1번 문제:
지문에서 바분(baboon) 실험을 통해 알 수 있는 인간 사회의 특징은 무엇입니까?
A. Human behavioral norms are mainly shaped by culture and learning
B. Human societies are less adaptable than baboon societies
C. Human behavior is determined only by biological factors
D. All societies have the same behavioral norms

~^^~''',
                ),
              ],
              role: 'assistant',
            ),
          ],
        ),
      ],
      prompt: [
        Prompt(
          id: 2,
          name: '빈칸',
          detail: '''아래 영어 지문을 “지문”으로 먼저 제시한 뒤, 빈칸 문제 1개를 실제 시험지처럼 만들어 주세요.
• 핵심 어휘 하나를 지문 내에서 고른 뒤 해당 단어를 ----로 대체해야 함(정답 단어는 보기로 포함)
• ** ⚠️ 해당 단어는 지문에 존재해서는 안되며, 같은 위치에 ----가 있어야 함**
• ** ⚠️ 반드시 지문 안에 ---- 가 있어야 됨**
• ** ⚠️ 정답 단어는 지문에 존재하지 않도록 지문을 수정할 것. **
• 객관식 보기(A~D)는 보기 단어만 나열 (지문 문장은 포함하지 말 것)
• 해설은 제외
• 문제는 한국어로 작성할 것.

# 1번 지문: {지문}

# 빈칸 1번 문제:
다음 빈칸에 들어갈 답을 고르시오.
A. ...
B. ...
C. ...
D. ...

"~^^~" 가 있다면 다른 지문(문제)으로 인식하고, 각 지문(문제) 별로 아래와 같이 정리해줘. 그리고 각 문제마다 이전과 똑같이 "~^^~"로 구분해줘.''',
        ),
        Prompt(
          id: 1,
          name: '객관식',
          detail: '''아래 영어 지문을 “지문”으로 먼저 제시한 뒤, 객관식 문제 1개를 실제 시험지처럼 만들어 주세요.
• 보기 A~D, 문항과 보기는 영어로 작성
• 해설은 제외
• 문제는 한국어로 작성할 것.
• 정답은 표시하지 않아도 됨.
• 지문,문제 앞에 붙는 '#'은 반드시 넣어줄 것

# 1번 지문: {지문}

# 객관식 1번 문제:
{생성된 문제}
A. ...
B. ...
C. ...
D. ...

"~^^~" 가 있다면 다른 지문(문제)으로 인식하고, 각 지문(문제) 별로 아래와 같이 정리해줘. 그리고 각 문제마다 이전과 똑같이 "~^^~"로 구분해줘.''',
        ),
      ],
    );
  }
}
