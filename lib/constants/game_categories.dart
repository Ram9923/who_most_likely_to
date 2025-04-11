import 'package:flutter/material.dart';

// Helper function to get the appropriate text based on language
String getLocalizedText(Map<String, String> texts, String language) {
  return texts[language] ?? texts['en'] ?? '';
}

// Game categories with translations
final Map<String, Map<String, dynamic>> categories = const {
  'fun': {
    'name': {'en': 'Fun & Casual', 'ar': 'ممتع وعادي'},
    'description': {
      'en': 'Lighthearted questions perfect for any group',
      'ar': 'أسئلة خفيفة مثالية لأي مجموعة',
    },
    'icon': Icons.sentiment_very_satisfied,
    'color': Colors.orange,
    'questions': [
      {
        'en': "Who's most likely to forget their keys?",
        'ar': "من الأرجح أن ينسى مفاتيحه؟",
      },
      {
        'en': "Who's most likely to become famous?",
        'ar': "من الأرجح أن يصبح مشهورًا؟",
      },
      {
        'en': "Who's most likely to sleep through their alarm?",
        'ar': "من الأرجح أن ينام أثناء المنبه؟",
      },
      {
        'en': "Who's most likely to win the lottery and lose the ticket?",
        'ar': "من الأرجح أن يفوز باليانصيب ويخسر التذكرة؟",
      },
      {
        'en': "Who's most likely to become a CEO?",
        'ar': "من الأرجح أن يصبح مديرًا تنفيذيًا؟",
      },
      {
        'en': "Who's most likely to move to another country?",
        'ar': "من الأرجح أن ينتقل إلى بلد آخر؟",
      },
      {
        'en': "Who's most likely to adopt 5 pets?",
        'ar': "من الأرجح أن يتبنى 5 حيوانات أليفة؟",
      },
      {
        'en': "Who's most likely to appear on a reality TV show?",
        'ar': "من الأرجح أن يظهر في برنامج تلفزيوني واقعي؟",
      },
      {
        'en': "Who's most likely to start their own business?",
        'ar': "من الأرجح أن يبدأ عمله الخاص؟",
      },
      {
        'en': "Who's most likely to get lost using GPS?",
        'ar': "من الأرجح أن يضيع باستخدام نظام تحديد المواقع؟",
      },
      {
        'en':
            "Who's most likely to accidentally send a text to the wrong person?",
        'ar': "من الأرجح أن يرسل رسالة نصية بالخطأ إلى الشخص الخطأ؟",
      },
      {
        'en': "Who's most likely to laugh at inappropriate moments?",
        'ar': "من الأرجح أن يضحك في لحظات غير مناسبة؟",
      },
      {
        'en': "Who's most likely to forget an important event?",
        'ar': "من الأرجح أن ينسى حدثًا مهمًا؟",
      },
      {
        'en': "Who's most likely to spend all their money on gadgets?",
        'ar': "من الأرجح أن ينفق كل أمواله على الأجهزة؟",
      },
      {
        'en': "Who's most likely to bring up a topic no one cares about?",
        'ar': "من الأرجح أن يثير موضوعًا لا يهتم به أحد؟",
      },
    ],
  },
  'adventures': {
    'name': {'en': 'Adventures & Travel', 'ar': 'المغامرات والسفر'},
    'description': {
      'en': 'For the thrill seekers and explorers',
      'ar': 'للمغامرين والمستكشفين',
    },
    'icon': Icons.flight,
    'color': Colors.blue,
    'questions': [
      {
        'en': "Who's most likely to go skydiving?",
        'ar': "من الأرجح أن يمارس القفز بالمظلة؟",
      },
      {
        'en': "Who's most likely to travel without a plan?",
        'ar': "من الأرجح أن يسافر بدون خطة؟",
      },
      {
        'en': "Who's most likely to live in another country?",
        'ar': "من الأرجح أن يعيش في بلد آخر؟",
      },
      {
        'en': "Who's most likely to climb a mountain?",
        'ar': "من الأرجح أن يتسلق جبلًا؟",
      },
      {
        'en': "Who's most likely to swim with sharks?",
        'ar': "من الأرجح أن يسبح مع أسماك القرش؟",
      },
      {
        'en': "Who's most likely to take a spontaneous road trip?",
        'ar': "من الأرجح أن يقوم برحلة برية عفوية؟",
      },
      {
        'en': "Who's most likely to go backpacking through Europe?",
        'ar': "من الأرجح أن يسافر بحقيبة ظهر عبر أوروبا؟",
      },
      {
        'en': "Who's most likely to learn a new language for fun?",
        'ar': "من الأرجح أن يتعلم لغة جديدة من أجل المتعة؟",
      },
      {
        'en': "Who's most likely to camp in the wilderness?",
        'ar': "من الأرجح أن يتخيم في البرية؟",
      },
      {
        'en': "Who's most likely to try an extreme sport?",
        'ar': "من الأرجح أن يجرب رياضة متطرفة؟",
      },
      {
        'en': "Who's most likely to go on a solo travel adventure?",
        'ar': "من الأرجح أن يذهب في مغامرة سفر منفردة؟",
      },
      {
        'en': "Who's most likely to move to a place they've never visited?",
        'ar': "من الأرجح أن ينتقل إلى مكان لم يزره من قبل؟",
      },
      {
        'en': "Who's most likely to explore the deep sea?",
        'ar': "من الأرجح أن يستكشف أعماق البحر؟",
      },
      {
        'en': "Who's most likely to become a travel blogger?",
        'ar': "من الأرجح أن يصبح مدون سفر؟",
      },
      {
        'en': "Who's most likely to hike the longest trail in the world?",
        'ar': "من الأرجح أن يسير في أطول مسار في العالم؟",
      },
    ],
  },
  'deep': {
    'name': {'en': 'Deep & Thoughtful', 'ar': 'عميق وذكي'},
    'description': {
      'en': 'More meaningful questions to spark conversation',
      'ar': 'أسئلة أكثر عمقًا لإثارة المحادثة',
    },
    'icon': Icons.psychology,
    'color': Colors.indigo,
    'questions': [
      {
        'en': "Who's most likely to change the world?",
        'ar': "من الأرجح أن يغير العالم؟",
      },
      {
        'en': "Who's most likely to write a book about their life?",
        'ar': "من الأرجح أن يكتب كتابًا عن حياته؟",
      },
      {
        'en': "Who's most likely to discover something important?",
        'ar': "من الأرجح أن يكتشف شيئًا مهمًا؟",
      },
      {
        'en': "Who's most likely to start a charity?",
        'ar': "من الأرجح أن يبدأ جمعية خيرية؟",
      },
      {
        'en': "Who's most likely to change careers completely?",
        'ar': "من الأرجح أن يغير مهنته تمامًا؟",
      },
      {
        'en': "Who's most likely to follow their passion regardless of money?",
        'ar': "من الأرجح أن يتبع شغفه بغض النظر عن المال؟",
      },
      {
        'en': "Who's most likely to make a sacrifice for someone else?",
        'ar': "من الأرجح أن يقدم تضحية من أجل شخص آخر؟",
      },
      {
        'en': "Who's most likely to stand up for what they believe in?",
        'ar': "من الأرجح أن يدافع عما يؤمن به؟",
      },
      {
        'en': "Who's most likely to find inner peace?",
        'ar': "من الأرجح أن يجد السلام الداخلي؟",
      },
      {
        'en': "Who's most likely to inspire others?",
        'ar': "من الأرجح أن يلهم الآخرين؟",
      },
      {
        'en': "Who's most likely to live without social media for a year?",
        'ar': "من الأرجح أن يعيش بدون وسائل التواصل الاجتماعي لمدة عام؟",
      },
      {
        'en': "Who's most likely to have a hidden talent no one knows about?",
        'ar': "من الأرجح أن يكون لديه موهبة خفية لا يعرفها أحد؟",
      },
      {
        'en': "Who's most likely to forgive someone who doesn't deserve it?",
        'ar': "من الأرجح أن يغفر لشخص لا يستحق ذلك؟",
      },
      {
        'en': "Who's most likely to pursue a cause they deeply care about?",
        'ar': "من الأرجح أن يتابع قضية يهتم بها بعمق؟",
      },
      {
        'en': "Who's most likely to never give up on their dreams?",
        'ar': "من الأرجح أن لا يستسلم أبدًا لأحلامه؟",
      },
    ],
  },
  'silly': {
    'name': {'en': 'Silly & Random', 'ar': 'سخيف وعشوائي'},
    'description': {
      'en': 'Ridiculous scenarios to make everyone laugh',
      'ar': 'سيناريوهات سخيفة لجعل الجميع يضحك',
    },
    'icon': Icons.mood,
    'color': Colors.pink,
    'questions': [
      {
        'en': "Who's most likely to trip on nothing?",
        'ar': "من الأرجح أن يتعثر في لا شيء؟",
      },
      {
        'en': "Who's most likely to laugh at the wrong moment?",
        'ar': "من الأرجح أن يضحك في اللحظة الخاطئة؟",
      },
      {
        'en': "Who's most likely to wear mismatched socks?",
        'ar': "من الأرجح أن يرتدي جوارب غير متطابقة؟",
      },
      {
        'en': "Who's most likely to talk to themselves?",
        'ar': "من الأرجح أن يتحدث مع نفسه؟",
      },
      {
        'en': "Who's most likely to dance in an elevator?",
        'ar': "من الأرجح أن يرقص في المصعد؟",
      },
      {
        'en':
            "Who's most likely to accidentally wear their clothes inside out?",
        'ar': "من الأرجح أن يرتدي ملابسه من الداخل للخارج بالخطأ؟",
      },
      {
        'en': "Who's most likely to get caught singing in the shower?",
        'ar': "من الأرجح أن يتم القبض عليه وهو يغني في الحمام؟",
      },
      {
        'en': "Who's most likely to eat something that fell on the floor?",
        'ar': "من الأرجح أن يأكل شيئًا سقط على الأرض؟",
      },
      {
        'en': "Who's most likely to argue with a GPS?",
        'ar': "من الأرجح أن يتجادل مع نظام تحديد المواقع؟",
      },
      {
        'en':
            "Who's most likely to text while walking and bump into something?",
        'ar': "من الأرجح أن يرسل رسائل نصية أثناء المشي ويصطدم بشيء؟",
      },
      {
        'en': "Who's most likely to use silly voices when talking to animals?",
        'ar': "من الأرجح أن يستخدم أصواتًا سخيفة عند التحدث مع الحيوانات؟",
      },
      {
        'en': "Who's most likely to take 50 selfies before posting one?",
        'ar': "من الأرجح أن يلتقط 50 صورة سيلفي قبل نشر واحدة؟",
      },
      {
        'en': "Who's most likely to send a voice note instead of a text?",
        'ar': "من الأرجح أن يرسل مقطع صوتي بدلاً من رسالة نصية؟",
      },
      {
        'en':
            "Who's most likely to try to start a trend that never catches on?",
        'ar': "من الأرجح أن يحاول بدء موضة لا تنتشر أبدًا؟",
      },
      {
        'en': "Who's most likely to wear pajamas to a party?",
        'ar': "من الأرجح أن يرتدي ملابس النوم في حفلة؟",
      },
    ],
  },
  'romance': {
    'name': {'en': 'Dating & Romance', 'ar': 'المواعدة والرومانسية'},
    'description': {
      'en': 'Questions about love, dating and relationships',
      'ar': 'أسئلة عن الحب والمواعدة والعلاقات',
    },
    'icon': Icons.favorite,
    'color': Colors.redAccent,
    'questions': [
      {
        'en': "Who's most likely to fall in love at first sight?",
        'ar': "من الأرجح أن يقع في الحب من النظرة الأولى؟",
      },
      {
        'en': "Who's most likely to have a secret crush?",
        'ar': "من الأرجح أن يكون لديه إعجاب سري؟",
      },
      {
        'en': "Who's most likely to propose in public?",
        'ar': "من الأرجح أن يتقدم بطلب الزواج في مكان عام؟",
      },
      {
        'en': "Who's most likely to have the most interesting dating story?",
        'ar': "من الأرجح أن يكون لديه أكثر قصة مواعدة إثارة للاهتمام؟",
      },
      {
        'en': "Who's most likely to date someone completely opposite to them?",
        'ar': "من الأرجح أن يواعد شخصًا معاكسًا تمامًا له؟",
      },
      {
        'en': "Who's most likely to flirt with a stranger?",
        'ar': "من الأرجح أن يغازل غريبًا؟",
      },
      {
        'en': "Who's most likely to have the most romantic date planned?",
        'ar': "من الأرجح أن يكون لديه أكثر موعد رومانسي مخطط له؟",
      },
      {
        'en': "Who's most likely to get back with their ex?",
        'ar': "من الأرجح أن يعود مع شريكه السابق؟",
      },
      {
        'en': "Who's most likely to fall asleep during a date?",
        'ar': "من الأرجح أن ينام أثناء الموعد؟",
      },
      {
        'en':
            "Who's most likely to date someone their friends don't approve of?",
        'ar': "من الأرجح أن يواعد شخصًا لا يوافق أصدقاؤه عليه؟",
      },
      {
        'en': "Who's most likely to believe in soulmates?",
        'ar': "من الأرجح أن يؤمن بالأرواح التوأم؟",
      },
      {
        'en': "Who's most likely to have a long-distance relationship?",
        'ar': "من الأرجح أن تكون لديه علاقة عن بعد؟",
      },
      {
        'en': "Who's most likely to have the most dramatic breakup?",
        'ar': "من الأرجح أن يكون لديه أكثر انفصال درامي؟",
      },
      {
        'en': "Who's most likely to send love letters?",
        'ar': "من الأرجح أن يرسل رسائل حب؟",
      },
      {
        'en': "Who's most likely to get caught having a secret date?",
        'ar': "من الأرجح أن يتم القبض عليه في موعد سري؟",
      },
    ],
  },
  'dirty': {
    'name': {'en': 'Edgy & Scandalous', 'ar': 'مثير للجدل وفاضح'},
    'description': {
      'en': 'For mature players only - more risqué questions',
      'ar': 'لللاعبين الناضجين فقط - أسئلة أكثر إثارة',
    },
    'icon': Icons.whatshot,
    'color': Colors.deepPurple,
    'questions': [
      {
        'en': "Who's most likely to get a risqué tattoo?",
        'ar': "من الأرجح أن يحصل على وشم مثير؟",
      },
      {
        'en': "Who's most likely to tell a scandalous secret?",
        'ar': "من الأرجح أن يخبر بسر فاضح؟",
      },
      {
        'en': "Who's most likely to streak in public?",
        'ar': "من الأرجح أن يجري عارياً في مكان عام؟",
      },
      {
        'en': "Who's most likely to have the wildest dating history?",
        'ar': "من الأرجح أن يكون لديه أكثر تاريخ مواعدة جامح؟",
      },
      {
        'en': "Who's most likely to have an outrageous guilty pleasure?",
        'ar': "من الأرجح أن يكون لديه متعة مذنبة صادمة؟",
      },
      {
        'en': "Who's most likely to get caught doing something embarrassing?",
        'ar': "من الأرجح أن يتم القبض عليه وهو يفعل شيئًا محرجًا؟",
      },
      {
        'en': "Who's most likely to have a secret admirer?",
        'ar': "من الأرجح أن يكون لديه معجب سري؟",
      },
      {
        'en': "Who's most likely to flirt with everyone in the room?",
        'ar': "من الأرجح أن يغازل الجميع في الغرفة؟",
      },
      {
        'en': "Who's most likely to send a spicy text to the wrong person?",
        'ar': "من الأرجح أن يرسل رسالة نصية حارة للشخص الخطأ؟",
      },
      {
        'en': "Who's most likely to have an unusual fantasy?",
        'ar': "من الأرجح أن يكون لديه خيال غير عادي؟",
      },
      {
        'en': "Who's most likely to be caught in a compromising position?",
        'ar': "من الأرجح أن يتم القبض عليه في موقف محرج؟",
      },
      {
        'en': "Who's most likely to have the most provocative social media?",
        'ar': "من الأرجح أن يكون لديه أكثر وسائل التواصل الاجتماعي استفزازًا؟",
      },
      {
        'en': "Who's most likely to kiss someone in front of a crowd?",
        'ar': "من الأرجح أن يقبل شخصًا أمام حشد؟",
      },
      {
        'en': "Who's most likely to post a scandalous picture online?",
        'ar': "من الأرجح أن ينشر صورة فاضحة على الإنترنت؟",
      },
      {
        'en': "Who's most likely to start an affair?",
        'ar': "من الأرجح أن يبدأ علاقة غرامية؟",
      },
    ],
  },
  'dirty2': {
    'name': {'en': 'More Edgy & Scandalous', 'ar': 'أكثر مثير للجدل وفاضح'},
    'description': {
      'en': 'For mature players only - more risqué questions',
      'ar': 'لللاعبين الناضجين فقط - أسئلة أكثر إثارة',
    },
    'icon': Icons.whatshot,
    'color': Colors.deepPurple,
    'questions': [
      {
        'en': "Who's most likely to wake up in a stranger's bed?",
        'ar': "من الأرجح أن يستيقظ في سرير شخص غريب؟",
      },
      {
        'en': "Who's most likely to lie about their number?",
        'ar': "من الأرجح أن يكذب بشأن عدد شركائه؟",
      },
      {
        'en': "Who's most likely to make out in a club?",
        'ar': "من الأرجح أن يتبادل القبل في نادٍ ليلي؟",
      },
      {
        'en': "Who's most likely to send nudes?",
        'ar': "من الأرجح أن يرسل صورًا عارية؟",
      },
      {
        'en':
            "Who's most likely to have a secret friends-with-benefits situation?",
        'ar': "من الأرجح أن يكون لديه علاقة سرية مع صديق؟",
      },
      {
        'en': "Who's most likely to be into something kinky?",
        'ar': "من الأرجح أن يكون لديه ميول جنسية غريبة؟",
      },
      {
        'en': "Who's most likely to flirt their way out of trouble?",
        'ar': "من الأرجح أن يغازل للخروج من ورطة؟",
      },
      {
        'en': "Who's most likely to hook up with someone famous?",
        'ar': "من الأرجح أن يرتبط بشخص مشهور؟",
      },
      {
        'en': "Who's most likely to sneak out after a one-night stand?",
        'ar': "من الأرجح أن يهرب بعد علاقة ليلة واحدة؟",
      },
      {
        'en': "Who's most likely to make a move on a friend's ex?",
        'ar': "من الأرجح أن يحاول الارتباط بحبيب صديقه السابق؟",
      },
      {
        'en': "Who's most likely to have a crush on their boss?",
        'ar': "من الأرجح أن يكون لديه إعجاب برئيسه في العمل؟",
      },
      {
        'en': "Who's most likely to be banned from a dating app?",
        'ar': "من الأرجح أن يتم حظره من تطبيق مواعدة؟",
      },
      {
        'en': "Who's most likely to wear something super revealing?",
        'ar': "من الأرجح أن يرتدي شيئًا كاشفًا للغاية؟",
      },
      {
        'en': "Who's most likely to get involved in a love triangle?",
        'ar': "من الأرجح أن يكون جزءًا من مثلث حب؟",
      },
      {
        'en': "Who's most likely to ghost someone after a spicy night?",
        'ar': "من الأرجح أن يختفي بعد ليلة مثيرة؟",
      },
    ],
  },
  'explicit': {
    'name': {'en': 'Explicit & Unfiltered', 'ar': 'صريح وغير مفلتر'},
    'description': {
      'en':
          'Only for wild players who aren’t afraid to cross the line. NSFW, raw, and unfiltered content.',
      'ar':
          'للاعبين الجريئين فقط الذين لا يخافون من تجاوز الحدود. محتوى غير مناسب للعمل، جريء وصريح.',
    },
    'icon':
        Icons
            .explicit, // You can replace this with a more appropriate icon if needed
    'color': Colors.redAccent,
    'questions': [
      {
        'en': "Who's most likely to have a sex tape out there?",
        'ar': "من الأرجح أن يكون لديه فيديو جنسي منتشر؟",
      },
      {
        'en': "Who's most likely to join an adult content site?",
        'ar': "من الأرجح أن ينضم إلى موقع محتوى للكبار؟",
      },
      {
        'en': "Who's most likely to hook up in a public bathroom?",
        'ar': "من الأرجح أن يمارس علاقة في حمام عام؟",
      },
      {
        'en': "Who's most likely to be into role play in bed?",
        'ar': "من الأرجح أن يحب التمثيل في السرير؟",
      },
      {
        'en': "Who's most likely to have had a threesome?",
        'ar': "من الأرجح أن يكون قد شارك في علاقة ثلاثية؟",
      },
      {
        'en': "Who's most likely to use handcuffs in the bedroom?",
        'ar': "من الأرجح أن يستخدم الأصفاد في غرفة النوم؟",
      },
      {
        'en': "Who's most likely to have a secret fetish?",
        'ar': "من الأرجح أن يكون لديه انحراف جنسي سري؟",
      },
      {
        'en': "Who's most likely to have hooked up at work?",
        'ar': "من الأرجح أن يكون قد مارس علاقة في مكان العمل؟",
      },
      {
        'en': "Who's most likely to have slept with someone twice their age?",
        'ar': "من الأرجح أن يكون قد نام مع شخص ضعف عمره؟",
      },
      {
        'en': "Who's most likely to talk dirty over the phone?",
        'ar': "من الأرجح أن يتحدث بكلمات جنسية عبر الهاتف؟",
      },
      {
        'en': "Who's most likely to own a collection of adult toys?",
        'ar': "من الأرجح أن يمتلك مجموعة من الألعاب الجنسية؟",
      },
      {
        'en': "Who's most likely to have had a one-night stand they regret?",
        'ar': "من الأرجح أن يكون قد مارس علاقة ليلة واحدة وندم عليها؟",
      },
      {
        'en': "Who's most likely to send nudes just for fun?",
        'ar': "من الأرجح أن يرسل صورًا عارية لمجرد المتعة؟",
      },
      {
        'en': "Who's most likely to fantasize about someone in this room?",
        'ar': "من الأرجح أن يتخيل أحد الموجودين في هذه الغرفة بطريقة جنسية؟",
      },
      {
        'en': "Who's most likely to hook up just to get revenge?",
        'ar': "من الأرجح أن يرتبط فقط للانتقام؟",
      },
    ],
  },

  'fame': {
    'name': {'en': 'Fame & Celebs', 'ar': 'الشهرة والمشاهير'},
    'description': {
      'en': 'Spotlight moments and brushes with fame',
      'ar': 'لحظات تحت الأضواء ومواجهات مع الشهرة',
    },
    'icon': Icons.star,
    'color': Colors.amber,
    'questions': [
      {
        'en': "Who's most likely to meet a celebrity and play it cool?",
        'ar': "من الأرجح أن يلتقي بمشهور ويتصرف بهدوء؟",
      },
      {
        'en': "Who's most likely to get a selfie with a famous person?",
        'ar': "من الأرجح أن يلتقط سيلفي مع شخص مشهور؟",
      },
      {
        'en': "Who's most likely to become a viral meme?",
        'ar': "من الأرجح أن يصبح ميم فيروسي؟",
      },
      {
        'en': "Who's most likely to date a celebrity?",
        'ar': "من الأرجح أن يواعد مشهورًا؟",
      },
      {
        'en': "Who's most likely to crash a VIP party?",
        'ar': "من الأرجح أن يتسلل إلى حفلة VIP؟",
      },
      {
        'en': "Who's most likely to be mistaken for a celebrity?",
        'ar': "من الأرجح أن يتم الخلط بينه وبين مشهور؟",
      },
      {
        'en': "Who's most likely to get interviewed on TV?",
        'ar': "من الأرجح أن يتمت مقابلته على التلفاز؟",
      },
      {
        'en': "Who's most likely to trend on social media?",
        'ar': "من الأرجح أن يتصدر الترند على وسائل التواصل الاجتماعي؟",
      },
      {
        'en': "Who's most likely to star in a commercial?",
        'ar': "من الأرجح أن يظهر في إعلان تجاري؟",
      },
      {
        'en': "Who's most likely to have a celebrity feud?",
        'ar': "من الأرجح أن يكون لديه خصومة مع مشهور؟",
      },
      {
        'en': "Who's most likely to have a famous doppelgänger?",
        'ar': "من الأرجح أن يكون لديه شبيه مشهور؟",
      },
      {
        'en': "Who's most likely to appear on a podcast?",
        'ar': "من الأرجح أن يظهر في بودكاست؟",
      },
      {
        'en': "Who's most likely to photobomb a celeb?",
        'ar': "من الأرجح أن يفسد صورة مشهور؟",
      },
      {
        'en': "Who's most likely to end up on TMZ?",
        'ar': "من الأرجح أن ينتهي به المطاف في TMZ؟",
      },
      {
        'en': "Who's most likely to win a meet-and-greet contest?",
        'ar': "من الأرجح أن يفوز في مسابقة للقاء المشاهير؟",
      },
    ],
  },

  'football': {
    'name': {'en': 'Football Fever', 'ar': 'حمى كرة القدم'},
    'description': {
      'en': 'For fans of the beautiful game',
      'ar': 'لمحبي اللعبة الجميلة',
    },
    'icon': Icons.sports_soccer,
    'color': Colors.green,
    'questions': [
      {
        'en': "Who's most likely to cry after a match?",
        'ar': "من الأرجح أن يبكي بعد المباراة؟",
      },
      {
        'en': "Who's most likely to become a football coach?",
        'ar': "من الأرجح أن يصبح مدرب كرة قدم؟",
      },
      {
        'en': "Who's most likely to argue about offside rules?",
        'ar': "من الأرجح أن يتجادل حول قواعد التسلل؟",
      },
      {
        'en':
            "Who's most likely to watch a full season without missing a match?",
        'ar': "من الأرجح أن يشاهد موسمًا كاملاً دون تفويت أي مباراة؟",
      },
      {
        'en': "Who's most likely to break a TV during a match?",
        'ar': "من الأرجح أن يكسر التلفاز أثناء المباراة؟",
      },
      {
        'en': "Who's most likely to get into a football debate online?",
        'ar': "من الأرجح أن يدخل في نقاش عن كرة القدم عبر الإنترنت؟",
      },
      {
        'en': "Who's most likely to paint their face for a game?",
        'ar': "من الأرجح أن يرسم على وجهه للمباراة؟",
      },
      {
        'en': "Who's most likely to travel for a World Cup?",
        'ar': "من الأرجح أن يسافر من أجل كأس العالم؟",
      },
      {
        'en': "Who's most likely to skip work for a game?",
        'ar': "من الأرجح أن يتغيب عن العمل من أجل مباراة؟",
      },
      {
        'en': "Who's most likely to name their child after a footballer?",
        'ar': "من الأرجح أن يسمي طفله باسم لاعب كرة قدم؟",
      },
      {
        'en': "Who's most likely to fake an injury while playing?",
        'ar': "من الأرجح أن يتظاهر بإصابة أثناء اللعب؟",
      },
      {
        'en': "Who's most likely to own five football jerseys?",
        'ar': "من الأرجح أن يمتلك خمس قمصان كرة قدم؟",
      },
      {
        'en': "Who's most likely to play football in the rain?",
        'ar': "من الأرجح أن يلعب كرة القدم في المطر؟",
      },
      {
        'en': "Who's most likely to score an own goal?",
        'ar': "من الأرجح أن يسجل هدفًا في مرماه؟",
      },
      {
        'en': "Who's most likely to dream of being a pro player?",
        'ar': "من الأرجح أن يحلم بأن يصبح لاعبًا محترفًا؟",
      },
    ],
  },

  'astrology': {
    'name': {'en': 'Stars & Signs', 'ar': 'النجوم والأبراج'},
    'description': {
      'en': 'Celestial questions for zodiac lovers',
      'ar': 'أسئلة سماوية لمحبي الأبراج',
    },
    'icon': Icons.nights_stay,
    'color': Colors.deepOrange,
    'questions': [
      {
        'en':
            "Who's most likely to ask someone's star sign on the first meeting?",
        'ar': "من الأرجح أن يسأل عن برج شخص ما في أول لقاء؟",
      },
      {
        'en': "Who's most likely to blame Mercury retrograde?",
        'ar': "من الأرجح أن يلوم تراجع عطارد؟",
      },
      {
        'en': "Who's most likely to read daily horoscopes?",
        'ar': "من الأرجح أن يقرأ الأبراج اليومية؟",
      },
      {
        'en': "Who's most likely to date based on zodiac compatibility?",
        'ar': "من الأرجح أن يواعد بناءً على توافق الأبراج؟",
      },
      {
        'en': "Who's most likely to get a tarot reading?",
        'ar': "من الأرجح أن يحصل على قراءة التاروت؟",
      },
      {
        'en': "Who's most likely to believe in astrology 100%?",
        'ar': "من الأرجح أن يؤمن بعلم التنجيم 100%؟",
      },
      {
        'en': "Who's most likely to plan events based on moon phases?",
        'ar': "من الأرجح أن يخطط الأحداث بناءً على أطوار القمر؟",
      },
      {
        'en': "Who's most likely to use astrology as an excuse?",
        'ar': "من الأرجح أن يستخدم علم التنجيم كعذر؟",
      },
      {
        'en': "Who's most likely to know everyone's sign?",
        'ar': "من الأرجح أن يعرف برج الجميع؟",
      },
      {
        'en': "Who's most likely to have crystals in their room?",
        'ar': "من الأرجح أن يكون لديه بلورات في غرفته؟",
      },
      {
        'en': "Who's most likely to say 'that's such a Scorpio thing'?",
        'ar': "من الأرجح أن يقول 'هذا شيء نموذجي للعقرب'؟",
      },
      {
        'en': "Who's most likely to ask for your birth chart?",
        'ar': "من الأرجح أن يطلب خريطة ميلادك؟",
      },
      {
        'en': "Who's most likely to post astrology memes?",
        'ar': "من الأرجح أن ينشر ميمات عن الأبراج؟",
      },
      {
        'en': "Who's most likely to fall in love with an astrologer?",
        'ar': "من الأرجح أن يقع في حب منجم؟",
      },
      {
        'en': "Who's most likely to predict the future (wrongly)?",
        'ar': "من الأرجح أن يتنبأ بالمستقبل (بشكل خاطئ)؟",
      },
    ],
  },

  'random': {
    'name': {'en': 'Wildcard WTF', 'ar': 'بطاقة برية غريبة'},
    'description': {
      'en': 'Unexpected, weird, and oddly specific',
      'ar': 'غير متوقع، غريب، ومحدد بشكل غريب',
    },
    'icon': Icons.question_mark,
    'color': Colors.teal,
    'questions': [
      {
        'en': "Who's most likely to survive a zombie apocalypse?",
        'ar': "من الأرجح أن ينجو من نهاية العالم بالزومبي؟",
      },
      {
        'en': "Who's most likely to become a cult leader?",
        'ar': "من الأرجح أن يصبح زعيم طائفة؟",
      },
      {
        'en': "Who's most likely to be abducted by aliens?",
        'ar': "من الأرجح أن يتم اختطافه من قبل كائنات فضائية؟",
      },
      {
        'en': "Who's most likely to fight a goose and lose?",
        'ar': "من الأرجح أن يقاتل إوزة ويخسر؟",
      },
      {
        'en': "Who's most likely to accidentally time travel?",
        'ar': "من الأرجح أن يسافر عبر الزمن بالخطأ؟",
      },
      {
        'en': "Who's most likely to find a hidden treasure?",
        'ar': "من الأرجح أن يجد كنزًا مخفيًا؟",
      },
      {
        'en':
            "Who's most likely to eat something just to see what it tastes like?",
        'ar': "من الأرجح أن يأكل شيئًا فقط ليرى مذاقه؟",
      },
      {
        'en': "Who's most likely to have a conspiracy theory blog?",
        'ar': "من الأرجح أن يكون لديه مدونة نظريات المؤامرة؟",
      },
      {
        'en': "Who's most likely to challenge a ghost to a duel?",
        'ar': "من الأرجح أن يتحدى شبحًا في مبارزة؟",
      },
      {
        'en': "Who's most likely to have a second secret life?",
        'ar': "من الأرجح أن يكون لديه حياة سرية ثانية؟",
      },
      {
        'en': "Who's most likely to fall in love with an AI?",
        'ar': "من الأرجح أن يقع في حب الذكاء الاصطناعي؟",
      },
      {
        'en': "Who's most likely to join a secret society?",
        'ar': "من الأرجح أن ينضم إلى جمعية سرية؟",
      },
      {
        'en': "Who's most likely to have a bizarre superpower?",
        'ar': "من الأرجح أن يكون لديه قوة خارقة غريبة؟",
      },
      {
        'en': "Who's most likely to become a talking point in a documentary?",
        'ar': "من الأرجح أن يصبح موضوع نقاش في فيلم وثائقي؟",
      },
      {
        'en': "Who's most likely to become friends with a raccoon?",
        'ar': "من الأرجح أن يصادق راكونًا؟",
      },
    ],
  },
  'wouldYouRather': {
    'name': {'en': 'Would You Rather', 'ar': 'ماذا تفضل'},
    'description': {
      'en': 'Hard choices... with a twist: pick a player!',
      'ar': 'خيارات صعبة... مع لمسة: اختر لاعبًا!',
    },
    'icon': Icons.help_outline,
    'color': Colors.brown,
    'questions': [
      {
        'en': "Who's most likely to eat something gross rather than do a dare?",
        'ar': "من الأرجح أن يأكل شيئًا مقرفًا بدلاً من تنفيذ التحدي؟",
      },
      {
        'en': "Who would you rather be stuck with on a desert island?",
        'ar': "من تفضل أن تكون محتجزًا معه في جزيرة مهجورة؟",
      },
      {
        'en': "Who would you rather have plan your wedding?",
        'ar': "من تفضل أن يخطط حفل زفافك؟",
      },
      {
        'en': "Who would you rather prank call your ex?",
        'ar': "من تفضل أن يتصل بشريكك السابق بمزحة؟",
      },
      {
        'en': "Who would you rather go on a spontaneous trip with?",
        'ar': "من تفضل أن تسافر معه في رحلة عفوية؟",
      },
      {
        'en': "Who would you rather trust with your secrets?",
        'ar': "من تفضل أن تثق به مع أسرارك؟",
      },
      {
        'en': "Who would you rather trade lives with for a week?",
        'ar': "من تفضل أن تتبادل معه الحياة لمدة أسبوع؟",
      },
      {
        'en': "Who would you rather be your lawyer in court?",
        'ar': "من تفضل أن يكون محاميك في المحكمة؟",
      },
      {
        'en': "Who would you rather call to bail you out of jail?",
        'ar': "من تفضل أن تتصل به ليفديك من السجن؟",
      },
      {
        'en': "Who would you rather watch your pet while you're away?",
        'ar': "من تفضل أن يراقب حيوانك الأليف أثناء غيابك؟",
      },
      {
        'en': "Who would you rather have give you a makeover?",
        'ar': "من تفضل أن يقوم بتجديد مظهرك؟",
      },
      {
        'en': "Who would you rather be your wingman/wingwoman?",
        'ar': "من تفضل أن يكون مساعدك في المواعدة؟",
      },
      {
        'en': "Who would you rather face in a dance battle?",
        'ar': "من تفضل أن تواجهه في معركة رقص؟",
      },
      {
        'en': "Who would you rather be your partner in a game show?",
        'ar': "من تفضل أن يكون شريكك في برنامج ألعاب؟",
      },
      {
        'en': "Who would you rather switch parents with for a week?",
        'ar': "من تفضل أن تتبادل معه الآباء لمدة أسبوع؟",
      },
    ],
  },
  'test': {
    'name': {'en': 'Test Category', 'ar': 'فئة الاختبار'},
    'description': {
      'en': 'Even more impossible choices… choose a player!',
      'ar': 'خيارات أكثر استحالة... اختر لاعبًا!',
    },
    'icon': Icons.shuffle,
    'color': Colors.teal,
    'questions': [
      {
        'en': "Who would you rather be stranded with in the mountains?",
        'ar': "من تفضل أن تكون محتجزًا معه في الجبال؟",
      },
      {
        'en': "Who would you rather let pick your next tattoo?",
        'ar': "من تفضل أن يختار وشمك التالي؟",
      },
    ],
  },
  'techGaming': {
    'name': {'en': 'Tech & Gaming', 'ar': 'التكنولوجيا والألعاب'},
    'description': {
      'en': 'For the nerds, gamers, and tech lovers of the group',
      'ar': 'للنيردز، اللاعبين، ومحبي التكنولوجيا في المجموعة',
    },
    'icon': Icons.videogame_asset,
    'color': Colors.indigo,
    'questions': [
      {
        'en': "Who's most likely to rage quit a game?",
        'ar': "من الأرجح أن يغضب ويرمي اللعبة؟",
      },
      {
        'en': "Who's most likely to stay up all night gaming?",
        'ar': "من الأرجح أن يسهر طوال الليل للعب؟",
      },
      {
        'en': "Who's most likely to own every console?",
        'ar': "من الأرجح أن يمتلك كل أجهزة الألعاب؟",
      },
      {
        'en': "Who's most likely to build their own PC?",
        'ar': "من الأرجح أن يبني جهاز الكمبيوتر الخاص به؟",
      },
      {
        'en': "Who's most likely to stream on Twitch?",
        'ar': "من الأرجح أن يبث على تويش؟",
      },
      {
        'en': "Who's most likely to code their own app?",
        'ar': "من الأرجح أن يبرمج تطبيقه الخاص؟",
      },
      {
        'en': "Who's most likely to fall for a tech scam?",
        'ar': "من الأرجح أن يقع في فخ احتيال تكنولوجي؟",
      },
      {
        'en': "Who's most likely to wait in line for a new iPhone?",
        'ar': "من الأرجح أن ينتظر في الطابور للحصول على آيفون جديد؟",
      },
      {
        'en': "Who's most likely to own VR gear?",
        'ar': "من الأرجح أن يمتلك معدات الواقع الافتراضي؟",
      },
      {
        'en': "Who's most likely to play video games at work?",
        'ar': "من الأرجح أن يلعب ألعاب فيديو في العمل؟",
      },
      {
        'en': "Who's most likely to have the best gaming setup?",
        'ar': "من الأرجح أن يكون لديه أفضل إعداد للألعاب؟",
      },
      {
        'en': "Who's most likely to become a game developer?",
        'ar': "من الأرجح أن يصبح مطور ألعاب؟",
      },
      {
        'en': "Who's most likely to argue about Android vs iPhone?",
        'ar': "من الأرجح أن يتجادل حول أندرويد ضد آيفون؟",
      },
      {
        'en': "Who's most likely to hack something just for fun?",
        'ar': "من الأرجح أن يخترق شيئًا من أجل المتعة فقط؟",
      },
      {
        'en': "Who's most likely to rage over bad Wi-Fi?",
        'ar': "من الأرجح أن يغضب من ضعف الواي فاي؟",
      },
    ],
  },
  'school': {
    'name': {'en': 'School Days', 'ar': 'أيام المدرسة'},
    'description': {
      'en': 'Memories, mishaps, and all things school-related',
      'ar': 'ذكريات، مواقف محرجة، وكل ما يتعلق بالمدرسة',
    },
    'icon': Icons.school,
    'color': Colors.purpleAccent,
    'questions': [
      {
        'en': "Who's most likely to forget their homework?",
        'ar': "من الأرجح أن ينسى واجباته المدرسية؟",
      },
      {
        'en': "Who's most likely to be late every morning?",
        'ar': "من الأرجح أن يتأخر كل صباح؟",
      },
      {
        'en': "Who's most likely to have a crush on a teacher?",
        'ar': "من الأرجح أن يكون معجبًا بأحد المعلمين؟",
      },
      {
        'en': "Who's most likely to cheat and get caught?",
        'ar': "من الأرجح أن يغش ويتم القبض عليه؟",
      },
      {
        'en': "Who's most likely to be class clown?",
        'ar': "من الأرجح أن يكون مهرج الفصل؟",
      },
      {
        'en': "Who's most likely to fall asleep in class?",
        'ar': "من الأرجح أن ينام في الصف؟",
      },
      {
        'en': "Who's most likely to start a school rumor?",
        'ar': "من الأرجح أن يبدأ إشاعة في المدرسة؟",
      },
      {
        'en': "Who's most likely to ace a test without studying?",
        'ar': "من الأرجح أن ينجح في اختبار بدون دراسة؟",
      },
      {
        'en': "Who's most likely to skip school for no reason?",
        'ar': "من الأرجح أن يتغيب عن المدرسة بدون سبب؟",
      },
      {
        'en': "Who's most likely to write on the bathroom walls?",
        'ar': "من الأرجح أن يكتب على جدران الحمام؟",
      },
      {
        'en': "Who's most likely to be teacher's pet?",
        'ar': "من الأرجح أن يكون المفضل لدى المعلم؟",
      },
      {
        'en': "Who's most likely to be a hall monitor nobody respects?",
        'ar': "من الأرجح أن يكون مراقب ممر لا يحترمه أحد؟",
      },
      {
        'en': "Who's most likely to organize a school protest?",
        'ar': "من الأرجح أن ينظم احتجاجًا مدرسيًا؟",
      },
      {
        'en': "Who's most likely to break the vending machine?",
        'ar': "من الأرجح أن يكسر آلة البيع؟",
      },
      {
        'en': "Who's most likely to be prom king/queen?",
        'ar': "من الأرجح أن يكون ملك/ملكة حفل التخرج؟",
      },
    ],
  },
  'music': {
    'name': {'en': 'Music & Vibes', 'ar': 'الموسيقى والأجواء'},
    'description': {
      'en': 'Tastes, talents, and tunes that define the group',
      'ar': 'الأذواق، المواهب، والألحان التي تحدد المجموعة',
    },
    'icon': Icons.music_note,
    'color': Colors.pinkAccent,
    'questions': [
      {
        'en': "Who's most likely to know every lyric?",
        'ar': "من الأرجح أن يعرف كل كلمات الأغاني؟",
      },
      {
        'en': "Who's most likely to DJ at a party?",
        'ar': "من الأرجح أن يكون دي جي في الحفلة؟",
      },
      {
        'en': "Who's most likely to cry over a sad song?",
        'ar': "من الأرجح أن يبكي بسبب أغنية حزينة؟",
      },
      {
        'en': "Who's most likely to have amazing taste in music?",
        'ar': "من الأرجح أن يكون لديه ذوق رائع في الموسيقى؟",
      },
      {
        'en': "Who's most likely to be tone deaf?",
        'ar': "من الأرجح أن يكون أصم للنغمات؟",
      },
      {
        'en': "Who's most likely to sing in the shower?",
        'ar': "من الأرجح أن يغني في الحمام؟",
      },
      {
        'en': "Who's most likely to be a music producer?",
        'ar': "من الأرجح أن يكون منتج موسيقى؟",
      },
      {
        'en': "Who's most likely to have a playlist for every mood?",
        'ar': "من الأرجح أن يكون لديه قائمة تشغيل لكل مزاج؟",
      },
      {
        'en': "Who's most likely to be a karaoke star?",
        'ar': "من الأرجح أن يكون نجم الكاريوكي؟",
      },
      {
        'en': "Who's most likely to have a vinyl collection?",
        'ar': "من الأرجح أن يكون لديه مجموعة أسطوانات؟",
      },
      {
        'en': "Who's most likely to be a music teacher?",
        'ar': "من الأرجح أن يكون معلم موسيقى؟",
      },
      {
        'en': "Who's most likely to have perfect pitch?",
        'ar': "من الأرجح أن يكون لديه نغمة مثالية؟",
      },
      {
        'en': "Who's most likely to be in a band?",
        'ar': "من الأرجح أن يكون في فرقة موسيقية؟",
      },
      {
        'en': "Who's most likely to have a music blog?",
        'ar': "من الأرجح أن يكون لديه مدونة موسيقية؟",
      },
      {
        'en': "Who's most likely to be a concert photographer?",
        'ar': "من الأرجح أن يكون مصور حفلات موسيقية؟",
      },
    ],
  },
  'foodies': {
    'name': {'en': 'Foodies Only', 'ar': 'للمهووسين بالطعام فقط'},
    'description': {
      'en': 'Delicious debates and guilty cravings',
      'ar': 'مناقشات لذيذة وشهوات مذنبة',
    },
    'icon': Icons.fastfood,
    'color': Colors.deepPurpleAccent,
    'questions': [
      {
        'en': "Who's most likely to eat something off the floor?",
        'ar': "من الأرجح أن يأكل شيئًا من على الأرض؟",
      },
      {
        'en': "Who's most likely to be a food critic?",
        'ar': "من الأرجح أن يكون ناقد طعام؟",
      },
      {
        'en': "Who's most likely to eat the weirdest thing?",
        'ar': "من الأرجح أن يأكل أغرب شيء؟",
      },
      {
        'en': "Who's most likely to cook the best meal?",
        'ar': "من الأرجح أن يطبخ أفضل وجبة؟",
      },
      {
        'en': "Who's most likely to burn water?",
        'ar': "من الأرجح أن يحرق الماء؟",
      },
      {
        'en': "Who's most likely to order dessert first?",
        'ar': "من الأرجح أن يطلب الحلويات أولاً؟",
      },
      {
        'en': "Who's most likely to cry if food is bad?",
        'ar': "من الأرجح أن يبكي إذا كان الطعام سيئًا؟",
      },
      {
        'en': "Who's most likely to steal fries from your plate?",
        'ar': "من الأرجح أن يسرق البطاطس من طبقك؟",
      },
      {
        'en': "Who's most likely to eat 5 meals a day?",
        'ar': "من الأرجح أن يأكل 5 وجبات في اليوم؟",
      },
      {
        'en': "Who's most likely to post food pics online?",
        'ar': "من الأرجح أن ينشر صور الطعام على الإنترنت؟",
      },
      {
        'en': "Who's most likely to have weird food combos?",
        'ar': "من الأرجح أن يكون لديه تركيبات طعام غريبة؟",
      },
      {
        'en': "Who's most likely to bring snacks everywhere?",
        'ar': "من الأرجح أن يجلب وجبات خفيفة في كل مكان؟",
      },
      {
        'en': "Who's most likely to eat the last slice without asking?",
        'ar': "من الأرجح أن يأكل آخر شريحة بدون أن يسأل؟",
      },
      {
        'en': "Who's most likely to win a hot dog eating contest?",
        'ar': "من الأرجح أن يفوز في مسابقة أكل الهوت دوج؟",
      },
      {
        'en': "Who's most likely to make a mess while eating?",
        'ar': "من الأرجح أن يسبب فوضى أثناء الأكل؟",
      },
    ],
  },
  'sports': {
    'name': {'en': 'Sports & Games', 'ar': 'الرياضة والألعاب'},
    'description': {
      'en': 'Athletic achievements and competitive spirit',
      'ar': 'الإنجازات الرياضية والروح التنافسية',
    },
    'icon': Icons.sports,
    'color': Colors.orangeAccent,
    'questions': [
      {
        'en': "Who's most likely to win a marathon?",
        'ar': "من الأرجح أن يفوز في ماراثون؟",
      },
      {
        'en': "Who's most likely to be a professional athlete?",
        'ar': "من الأرجح أن يكون رياضيًا محترفًا؟",
      },
      {
        'en': "Who's most likely to get injured playing sports?",
        'ar': "من الأرجح أن يتأذى أثناء ممارسة الرياضة؟",
      },
      {
        'en': "Who's most likely to be a sports commentator?",
        'ar': "من الأرجح أن يكون معلقًا رياضيًا؟",
      },
      {
        'en': "Who's most likely to win at arm wrestling?",
        'ar': "من الأرجح أن يفوز في مصارعة الأذرع؟",
      },
      {
        'en': "Who's most likely to be a team captain?",
        'ar': "من الأرجح أن يكون قائد فريق؟",
      },
      {
        'en': "Who's most likely to break a world record?",
        'ar': "من الأرجح أن يحطم رقمًا قياسيًا عالميًا؟",
      },
      {
        'en': "Who's most likely to be a sports coach?",
        'ar': "من الأرجح أن يكون مدربًا رياضيًا؟",
      },
      {
        'en': "Who's most likely to win at chess?",
        'ar': "من الأرجح أن يفوز في الشطرنج؟",
      },
      {
        'en': "Who's most likely to be a sports fanatic?",
        'ar': "من الأرجح أن يكون مهووسًا بالرياضة؟",
      },
      {
        'en': "Who's most likely to win at video games?",
        'ar': "من الأرجح أن يفوز في ألعاب الفيديو؟",
      },
      {
        'en': "Who's most likely to be a sports referee?",
        'ar': "من الأرجح أن يكون حكمًا رياضيًا؟",
      },
      {
        'en': "Who's most likely to win at swimming?",
        'ar': "من الأرجح أن يفوز في السباحة؟",
      },
      {
        'en': "Who's most likely to be a sports photographer?",
        'ar': "من الأرجح أن يكون مصورًا رياضيًا؟",
      },
      {
        'en': "Who's most likely to win at basketball?",
        'ar': "من الأرجح أن يفوز في كرة السلة؟",
      },
    ],
  },
  'movies': {
    'name': {'en': 'Movies & TV', 'ar': 'الأفلام والتلفاز'},
    'description': {
      'en': 'Screen time, binge watching, and pop culture',
      'ar': 'وقت الشاشة، مشاهدة متواصلة، وثقافة البوب',
    },
    'icon': Icons.movie,
    'color': Colors.redAccent,
    'questions': [
      {
        'en': "Who's most likely to binge watch a series in one day?",
        'ar': "من الأرجح أن يشاهد مسلسلاً كاملاً في يوم واحد؟",
      },
      {
        'en': "Who's most likely to cry during movies?",
        'ar': "من الأرجح أن يبكي أثناء الأفلام؟",
      },
      {
        'en': "Who's most likely to be a movie critic?",
        'ar': "من الأرجح أن يكون ناقد أفلام؟",
      },
      {
        'en': "Who's most likely to watch horror movies alone?",
        'ar': "من الأرجح أن يشاهد أفلام الرعب بمفرده؟",
      },
      {
        'en': "Who's most likely to quote movies in conversations?",
        'ar': "من الأرجح أن يقتبس من الأفلام في المحادثات؟",
      },
      {
        'en': "Who's most likely to have seen every Marvel movie?",
        'ar': "من الأرجح أن يكون قد شاهد كل أفلام مارفل؟",
      },
      {
        'en': "Who's most likely to fall asleep during movies?",
        'ar': "من الأرجح أن ينام أثناء الأفلام؟",
      },
      {
        'en': "Who's most likely to be a movie director?",
        'ar': "من الأرجح أن يكون مخرج أفلام؟",
      },
      {
        'en': "Who's most likely to watch movies with subtitles?",
        'ar': "من الأرجح أن يشاهد الأفلام مع ترجمة؟",
      },
      {
        'en': "Who's most likely to have a movie collection?",
        'ar': "من الأرجح أن يكون لديه مجموعة أفلام؟",
      },
      {
        'en': "Who's most likely to watch movies in theaters?",
        'ar': "من الأرجح أن يشاهد الأفلام في السينما؟",
      },
      {
        'en': "Who's most likely to be a TV show host?",
        'ar': "من الأرجح أن يكون مقدم برنامج تلفزيوني؟",
      },
      {
        'en': "Who's most likely to watch documentaries?",
        'ar': "من الأرجح أن يشاهد الأفلام الوثائقية؟",
      },
      {
        'en': "Who's most likely to have a favorite movie genre?",
        'ar': "من الأرجح أن يكون لديه نوع أفلام مفضل؟",
      },
      {
        'en': "Who's most likely to watch movies with friends?",
        'ar': "من الأرجح أن يشاهد الأفلام مع الأصدقاء؟",
      },
    ],
  },
  'travel': {
    'name': {'en': 'Travel & Adventure', 'ar': 'السفر والمغامرة'},
    'description': {
      'en': 'Wanderlust, exploration, and travel tales',
      'ar': 'شغف السفر، الاستكشاف، وحكايات السفر',
    },
    'icon': Icons.flight,
    'color': Colors.tealAccent,
    'questions': [
      {
        'en': "Who's most likely to travel the world?",
        'ar': "من الأرجح أن يسافر حول العالم؟",
      },
      {
        'en': "Who's most likely to get lost in a new city?",
        'ar': "من الأرجح أن يضيع في مدينة جديدة؟",
      },
      {
        'en': "Who's most likely to be a travel blogger?",
        'ar': "من الأرجح أن يكون مدون سفر؟",
      },
      {
        'en': "Who's most likely to try exotic food?",
        'ar': "من الأرجح أن يجرب الطعام الغريب؟",
      },
      {
        'en': "Who's most likely to pack too much?",
        'ar': "من الأرجح أن يحزم الكثير من الأمتعة؟",
      },
      {
        'en': "Who's most likely to miss their flight?",
        'ar': "من الأرجح أن يفوت رحلته؟",
      },
      {
        'en': "Who's most likely to learn a new language?",
        'ar': "من الأرجح أن يتعلم لغة جديدة؟",
      },
      {
        'en': "Who's most likely to make friends while traveling?",
        'ar': "من الأرجح أن يصادق أشخاصًا أثناء السفر؟",
      },
      {
        'en': "Who's most likely to take the most photos?",
        'ar': "من الأرجح أن يلتقط أكبر عدد من الصور؟",
      },
      {
        'en': "Who's most likely to travel alone?",
        'ar': "من الأرجح أن يسافر بمفرده؟",
      },
      {
        'en': "Who's most likely to stay in luxury hotels?",
        'ar': "من الأرجح أن يقيم في فنادق فاخرة؟",
      },
      {
        'en': "Who's most likely to travel on a budget?",
        'ar': "من الأرجح أن يسافر بميزانية محدودة؟",
      },
      {
        'en': "Who's most likely to have travel insurance?",
        'ar': "من الأرجح أن يكون لديه تأمين سفر؟",
      },
      {
        'en': "Who's most likely to plan every detail?",
        'ar': "من الأرجح أن يخطط كل التفاصيل؟",
      },
      {
        'en': "Who's most likely to travel spontaneously?",
        'ar': "من الأرجح أن يسافر بشكل عفوي؟",
      },
    ],
  },
  'fashion': {
    'name': {'en': 'Fashion & Style', 'ar': 'الأزياء والأناقة'},
    'description': {
      'en': 'Trends, style, and fashion statements',
      'ar': 'الاتجاهات، الأناقة، وتصريحات الموضة',
    },
    'icon': Icons.style,
    'color': Colors.purpleAccent,
    'questions': [
      {
        'en': "Who's most likely to be a fashion designer?",
        'ar': "من الأرجح أن يكون مصمم أزياء؟",
      },
      {
        'en': "Who's most likely to follow fashion trends?",
        'ar': "من الأرجح أن يتبع اتجاهات الموضة؟",
      },
      {
        'en': "Who's most likely to have a unique style?",
        'ar': "من الأرجح أن يكون لديه أسلوب فريد؟",
      },
      {
        'en': "Who's most likely to spend too much on clothes?",
        'ar': "من الأرجح أن ينفق الكثير على الملابس؟",
      },
      {
        'en': "Who's most likely to be a fashion influencer?",
        'ar': "من الأرجح أن يكون مؤثرًا في مجال الموضة؟",
      },
      {
        'en': "Who's most likely to have a capsule wardrobe?",
        'ar': "من الأرجح أن يكون لديه خزانة ملابس بسيطة؟",
      },
      {
        'en': "Who's most likely to wear bold colors?",
        'ar': "من الأرجح أن يرتدي ألوانًا جريئة؟",
      },
      {
        'en': "Who's most likely to be a fashion photographer?",
        'ar': "من الأرجح أن يكون مصور أزياء؟",
      },
      {
        'en': "Who's most likely to have matching outfits?",
        'ar': "من الأرجح أن يكون لديه ملابس متناسقة؟",
      },
      {
        'en': "Who's most likely to shop online?",
        'ar': "من الأرجح أن يتسوق عبر الإنترنت؟",
      },
      {
        'en': "Who's most likely to have a signature accessory?",
        'ar': "من الأرجح أن يكون لديه إكسسوار مميز؟",
      },
      {
        'en': "Who's most likely to be a fashion model?",
        'ar': "من الأرجح أن يكون عارض أزياء؟",
      },
      {
        'en': "Who's most likely to have a fashion blog?",
        'ar': "من الأرجح أن يكون لديه مدونة أزياء؟",
      },
      {
        'en': "Who's most likely to wear vintage clothes?",
        'ar': "من الأرجح أن يرتدي ملابس قديمة؟",
      },
      {
        'en': "Who's most likely to have a fashion emergency?",
        'ar': "من الأرجح أن يكون لديه موقف طارئ متعلق بالملابس؟",
      },
    ],
  },
};
