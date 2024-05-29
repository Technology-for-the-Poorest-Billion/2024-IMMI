import 'package:flutter/material.dart';


class InfoPage extends StatelessWidget {
  final List<Map<String, dynamic>> stages = [
    {
      'title': 'Winter',
      'subtitle': 'Stage 1: Menstual Phase (Days 1-6)',
      'descriptionList':[
        'Biologically - Your uterus is shedding its lining that would have held the egg if it was fertilised. This lining has built up throughout the month and your body is now working hard to release the blood in the lining of your uterus, so it’s sending you all the signals to slow down and stop while it’s busy! ',
       'Emotionally - You may feel sensitive and tired.  It’s like a physical and emotional release when your period comes, all the emotions can fly away too and tension can be released! You can take this time to really nurture yourself, get lots of sleep and even wear nice big warm jumpers.',
       'Physically - Expect some pain and fatigue. Taking this downtime now will set you up for the rest of your cycle. If you don’t slow down, you may end up running on empty later which can make your PMS really intense.',
       'Exercise - Gentle exercise like walking or stretching. After a few days of bleeding you might feel energised so don’t hold back from an easy run if your body wants that. ',
       'Diet - Increase iron intake with foods like granola, chicken, and leafy greens. Snacks like raisins and dried apricots are good too, and some orange juice. ',
      ],  
      'color': '0xFFFFCDD2'
    },
    {
      'title': 'Spring',
      'subtitle': 'Stage 2: Follicular Phase (Days 7-13)',
      'descriptionList': [
        'Biologically - Your egg is preparing to be released. The egg leaves the ovary and travels down the fallopian tube towards the uterus. During this journey the egg will meet the sperm (if there is sperm present) and get fertilized to produce pregnancy.',
       'Emotionally - Feel more energetic and optimistic. Our oestrogen levels start to rise and we start to feel more energy, more motivation and full of hope, optimism and ideas.',
       'Physically - Ready to exercise and take on new projects. Your creative juices are starting to flow so make the most of it. Meet up with friends, socialise and feel the energy!',
       'Exercise - Pre-ovulation, your body temperature stays consistent, pain tolerance increases and the ability to digest and utilise carbohydrates is more efficient. So, in other words, go out and shift some steel and hit those personal bests! Be careful though as your ligaments and tendons are a bit more relaxed thanks to oestrogen, so don’t overstretch or do too much flexibility work during this phase as you might pull a muscle or twist an ankle or something!',
       'Diet - Salads with broccoli, salmon, and fermented foods to help with your gut. Nuts are a great snack also - you may consider these during your working day to remain energised and focused!',
      ],         
      'color': '0xFFC8E6C9'
    },
    {
      'title': 'Summer',
      'subtitle': 'Stage 3: Ovulation Phase (Days 14-19)',
      'descriptionList': [
        'Biologically - You\'re at your peak of ovulation. There’s actually only 24hours in which your egg can survive. If you have a regular cycle, you usually ovulate around day 13-15 but this can still vary. Sperm can last for up to 6 days so if you’re sexually active and don’t want to get pregnant, use protection or abstain. Your egg will carry on happily through the uterus if it doesn’t get fertilized.',
        'Emotionally - High energy, sociability, and productivity. Your oestrogen will be peaking as you’re due to ovulate so everything about you is saying YES. You’re likely to have heaps of energy, feeling like a social butterfly and being super productive at work / uni too.',
        'Physically - Tackle big tasks and enjoy social activities. You’ll feel more sociable so schedule in some friend time or activities. And, yes, your biology means that you’re more likely to get pregnant, so honestly, if you find yourself feeling flirty, this is why! It’s kind of mental... ',
        'Exercise - Weight training or cardio without quick movements. Towards the end of your third phase, you’ll start to feel less energetic so stay mindful and listen to your body.',
        'Diet - Wholegrain foods, fresh berries, and foods to help the liver remove excess oestrogen.',
      ],
       'color': '0xFFBBDEFB'
    },
    {
      'title': 'Autumn',
      'subtitle': 'Stage 4: Luteal Phase (Days 20-28)',
      'descriptionList': [
        'Biologically - The body is preparing to receive the fertilized egg and the inner wall of the uterus (the uterine lining) grows thicker, creating a nourishing place for it to grow into a human. If there isn’t an egg that’s been fertilized by sperm during ovulation phase, then there’s no need for the uterine lining, so it is released. ',
        'Emotionally - During autumn your oestrogen dips and progesterone begins to rise. Progesterone is a hormone which is all about slowing right down.You’ll start to feel quite sensitive and emotional during the final few days, and you might even notice that you have a few days where you get really angry or start crying for no reason.',
        'Physically - Lethargic and bloated with decreased energy. ou may notice you have less energy and you feel like there are only certain people (or sometimes no people) you want to be around. In the days before your period, you may also be feeling more sensitive and extra critical - to yourself and/or others. ',
        'Exercise - Yoga, gentle workouts, and meditation. Progesterone is also a “calming hormone”. It may increase sleep, but also can affect the way the brain picks up new skills. ',
        'Diet - Slow-burning carbs and fiber-rich foods, and lots of water. Going easy on caffeine will also help, I know it’s hard though! But if you’re feeling a bit anxious it’s definitely worth it for a few days.',
       ],
      'color': '0xFFFFF9C4'
    },
  ];

  final List<Map<String, dynamic>> additionalSections = [
    {
      'title': 'Common Symptoms & Tips',
      'description':
          'Information on common symptoms experienced during each phase and tips for managing them.',
        'bullets': [
          'Abdominal Cramps - Menstrual cramps are felt in the lower abdomen. The achy, cramping feeling may also radiate out toward your lower back and upper thighs. The cramps are caused by uterine contractions, which help shed the inner lining of the uterus (endometrium) when a pregnancy doesn’t take place. Tips for dealing with cramps are using a hot waterbottle on your abdomin or taking a rest day when your cramps are the worst.',
          'Breakouts - Menstruation-related breakouts are fairly common. These pre-period breakouts often erupt on the chin and jawline, but can appear anywhere on the face, back, or other areas of the body. The acne is caused by the natural hormonal changes associated with the female reproductive cycle. Period-related acne often dissipates near the end of menstruation or shortly afterward when estrogen and progesterone levels start to climb.',
          'Tender Breasts - Progesterone levels start to rise in the middle of your cycle, around ovulation. This makes the mammary glands in your breasts enlarge and swell. These changes cause your breasts to get an achy, swollen feeling right before or during your period, even as progesterone levels lower once again.',
          'Fatigue - As your period approaches, your body shifts gears from getting ready to sustain a pregnancy to getting ready to menstruate. Hormone levels plummet, and fatigue is often the result. Mood changes may also make you feel tired.',
          'Bloating - If your tummy feels heavy or it feels like you can’t get your jeans to zip up a few days before your period, you may have PMS bloating. Changes in estrogen and progesterone levels can cause your body to retain more water and salt than usual. That results in a bloated feeling.',  
        ],
      'color': '0xFFE1BEE7'
    },
    {
      'title': 'About IMMI',
      'description':
          'The purpose of IMMI is to help you learn about and track your menstrual cycle. IMMI uses numbers to count the days of the menstrual cycle, and icons to track its phases. The website is easy to use. You don’t need to do anything on each day, you only need to do something on Day 1 of your period, when is Day 1 of your period?. The first day you start bleeding. It’s very easy to use, fashionable and ensures your period is not a surprise!',
      'color': '0xFFE0F7FA'
    },
  ];

  final List<Map<String, String>> faqSection = [
    {
      'question': 'Q: What is the menstrual cycle?',
      'answer':
          'A: The menstrual cycle is a series of natural changes in hormone production and the structures of the uterus and ovaries that make pregnancy possible.'
    },
    {
      'question': 'Q: Is menstruation painful?',
      'answer':
          'A: Some girls experience abdominal cramps before or during their period. This can feel like a stomach ache. These menstrual cramps occur because the uterus is contracting to expel the lining. Menstrual cramps are not usually a serious problem and can often be treated with a pain reliever, exercise, a hot bath, or a hot water bottle placed on the abdomen. Pain usually only lasts the first 2– 3 days of the period. Some girls may also experience lower back pain, headaches, nausea, vomiting, or changes in moods.'
    },
    {
      'question': 'Q: What is considered “normal” bleeding or pain, and when should I consult a doctor?',
      'answer':
          'A: Menstrual cramps are very normal and many women experience them just before and during menstruation. For many women, these cramps do not interfere with their everyday activities. However, for others they can be severe and interfere with school, work and social activities. Menstrual cramps can be the result of conditions like endometriosis and uterine fibroids. If cramps disrupt your life every month or if your symptoms progressively get worse, you should see your doctor. Heavy menstrual bleeding includes bleeding that lasts more than 7 days, bleeding that requires one or more pads every hour for several hours, bleeding that requires girls or women to change their pads during the night, or having large blood clots (e.g., 2.5 cm or larger).'
    },
    {
      'question': 'Q: What are common symptoms during the menstrual cycle?',
      'answer':
          'A: Common symptoms include cramps, bloating, mood swings, and headaches. These can vary from person to person.'
    },
    {
      'question': 'Q: Will everyone know when I am on my period?',
      'answer':
          'A: No, only you will know you are on your period. Menstrual hygiene products such as pads, tampons and menstrual cups are not visible through clothing. Of course, you should feel comfortable talking with friends and trusted adults about your period. It is nothing to be embarrassed about!'
    },
    {
      'question': 'Q: Why is my period irregular?',
      'answer':
          'A: It is very common to have irregular or skipped periods, especially in the first 2 years after a girl first menstruates. Some girls may also experience illness, rapid weight change or stress. It is normal for period length to vary from cycle to cycle. For example, sometimes a girl may bleed for 2 days, at other times it may last a week. However if you start to feel unusual pain you should tell your parents/teachers and seek medical attention.'
    },
    {
      'question': 'Q: Is it safe to exercise while I am on my period?',
      'answer':
          'A: It is completely safe to exercise while menstruating! Exercising can also help relieve the symptoms of menstrual cramps and trigger the release of endorphins, which make you feel happy!'
    },
    {
      'question': 'Q: Is it dangerous to have sex while on your period?',
      'answer':
          'A: It is perfectly safe to have sex during your period. It is a matter of personal preference between partners. Remember that it is still possible to get pregnant during this time. Sex you had during menstruation can lead to pregnancy because sperm can remain in your body for several days. In addition, menstrual cycles may vary even for the same individual, which makes it very difficult to pinpoint the exact timing of ovulation. It is also still possible to transmit STIs, so always use proper protection (e.g., condoms). '
    },
    {
      'question': 'Q: Can you feel ovulation?',
      'answer':
          'A: Most women do not notice when ovulation occurs. Some women may feel a pain in their side when ovulation takes place, but it can easily be mistaken for other types of abdominal cramps. Women who are trying to get pregnant may purchase ovulation tests to track their ovulation more precisely.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'),
        backgroundColor: Color.fromARGB(255, 255, 217, 187),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TitleSection(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.15,
                ),
                itemCount: stages.length,
                itemBuilder: (context, index) {
                  return StageCard(
                    title: stages[index]['title']!,
                    subtitle: stages[index]['subtitle']!,
                    descriptionlist: stages[index]['descriptionList'] as List<String>,
                    backgroundColor: Color(int.parse(stages[index]['color']!)),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: additionalSections.length,
                itemBuilder: (context, index) {
                final section = additionalSections[index];
                  if (section.containsKey('bullets')) {
                    return AdditionalSection(
                      title: additionalSections[index]['title']!,
                      description: additionalSections[index]['description']!,
                      bullets: additionalSections[index]['bullets'] as List<String>,
                      backgroundColor: Color(int.parse(additionalSections[index]['color']!)),
                  );
                  } else {
                    return AdditionalSectionAbout(
                      title: section['title']!,
                      description: section['description']!,
                      backgroundColor: Color(int.parse(section['color']!)),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FaqSection(faqSection: faqSection),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 16.0),
          Text(
            'Understanding the Menstrual Cycle',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            'Your menstrual cycle is every day of your life (until menapause!) so it’s important to track it. Each day, something different is happening so that’s why you’ll feel different during different phases of your cycle. We can break your cycle into 4 parts, it’s easy to understand them if you think about it like the Seasons.',
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class StageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> descriptionlist;
  final Color backgroundColor;

  StageCard({
    required this.title,
    required this.subtitle,
    required this.descriptionlist,
    required this.backgroundColor, 
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.0),
            Text(
              subtitle,
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 5.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: descriptionlist.map((list) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.spa, size: 16),
                    SizedBox(width: 10.0),
                    Expanded(child: Text(list, style: TextStyle(fontSize: 14.0))),
                  ],
                ),
              )).toList(),
            ),
          ]
              ),
            ),
          
        );
  }
}

class AdditionalSection extends StatelessWidget {
  final String title;
  final String description;
  final List<String> bullets;
  final Color backgroundColor;

  AdditionalSection({
    required this.title,
    required this.description,
    required this.bullets,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bullets.map((bullet) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_forward, size: 18),
                    SizedBox(width: 10.0),
                    Expanded(child: Text(bullet, style: TextStyle(fontSize: 14.0))),
                  ],
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class AdditionalSectionAbout extends StatelessWidget {
  final String title;
  final String description;
  final Color backgroundColor;

  AdditionalSectionAbout({
    required this.title,
    required this.description,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
          Text(description, style: const TextStyle(fontSize: 14.0)),

          ],
        ),
      ),
    );
  }
}

class FaqSection extends StatelessWidget {
  final List<Map<String, String>> faqSection;

  const FaqSection({required this.faqSection});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FAQ Section',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        ...faqSection.map((faq) {
          return Card(
            child: ExpansionTile(
              title: Text(faq['question']!, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(faq['answer']!, style: TextStyle(fontSize: 14.0)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
