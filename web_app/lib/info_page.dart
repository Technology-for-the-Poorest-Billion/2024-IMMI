import 'package:flutter/material.dart';
import 'package:bulleted_list/bulleted_list.dart';


void main() {
  runApp(PeriodTrackerApp());
}

class PeriodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Period Tracker',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      scrollBehavior: const MaterialScrollBehavior()
    .copyWith(scrollbars: true),
      home: InfoPage(),
    );
  }
}


class InfoPage extends StatelessWidget {
 final List<Stage> stages = [
  Stage(
      title: 'Winter',
      description: 'Phase 1 (Days 1-6): Rest and nurture yourself during your period. It’s the phase when you’re on your period (bleeding) and it’s the time to rest, like you’re hibernating in winter! ',
      biologically: 'Your uterus is shedding its lining that would have held the egg if it was fertilised. This lining has built up throughout the month and your body is now working hard to release the blood in the lining of your uterus, so it’s sending you all the signals to slow down and stop while it’s busy! ',
      emotionally: 'You may feel sensitive and tired.  It’s like a physical and emotional release when your period comes, all the emotions can fly away too and tension can be released! You can take this time to really nurture yourself, get lots of sleep and even wear nice big warm jumpers.',
      physically: 'Expect some pain and fatigue. Taking this downtime now will set you up for the rest of your cycle. If you don’t slow down, you may end up running on empty later which can make your PMS really intense.',
      exercise: 'Gentle exercise like walking or stretching. After a few days of bleeding you might feel energised so don’t hold back from an easy run if your body wants that. ',
      diet: 'Increase iron intake with foods like granola, chicken, and leafy greens. Snacks like raisins and dried apricots are good too, and some orange juice. ',
      color: Colors.lightBlueAccent,
    ),
    Stage(
      title: 'Spring',
      description: 'Phase 2 (Days 7-13): Your period has finished. Energy and motivation rise as you prepare to ovulate.',
      biologically: 'Your egg is preparing to be released. The egg leaves the ovary and travels down the fallopian tube towards the uterus. During this journey the egg will meet the sperm (if there is sperm present) and get fertilized to produce pregnancy.',
      emotionally: 'Feel more energetic and optimistic. Our oestrogen levels start to rise and we start to feel more energy, more motivation and full of hope, optimism and ideas.',
      physically: 'Ready to exercise and take on new projects. Your creative juices are starting to flow so make the most of it. Meet up with friends, socialise and feel the energy!',
      exercise: 'Pre-ovulation, your body temperature stays consistent, pain tolerance increases and the ability to digest and utilise carbohydrates is more efficient. So, in other words, go out and shift some steel and hit those personal bests! Be careful though as your ligaments and tendons are a bit more relaxed thanks to oestrogen, so don’t overstretch or do too much flexibility work during this phase as you might pull a muscle or twist an ankle or something!',
      diet: 'Salads with broccoli, salmon, and fermented foods to help with your gut. Nuts are a great snack also - you may consider these during your working day to remain energised and focused!',
      color: Colors.greenAccent,
    ),
    Stage(
      title: 'Summer',
      description: 'Phase 3 (Days 14-19): Ovulation peaks, with high energy and sociability.',
      biologically: 'You\'re at your peak of ovulation. There’s actually only 24hours in which your egg can survive. If you have a regular cycle, you usually ovulate around day 13-15 but this can still vary. Sperm can last for up to 6 days so if you’re sexually active and don’t want to get pregnant, use protection or abstain. Your egg will carry on happily through the uterus if it doesn’t get fertilized.',
      emotionally: 'High energy, sociability, and productivity. Your oestrogen will be peaking as you’re due to ovulate so everything about you is saying YES. You’re likely to have heaps of energy, feeling like a social butterfly and being super productive at work / uni too.',
      physically: 'Tackle big tasks and enjoy social activities. You’ll feel more sociable so schedule in some friend time or activities. And, yes, your biology means that you’re more likely to get pregnant, so honestly, if you find yourself feeling flirty, this is why! It’s kind of mental... ',
      exercise: 'Weight training or cardio without quick movements. Towards the end of your third phase, you’ll start to feel less energetic so stay mindful and listen to your body.',
      diet: 'Wholegrain foods, fresh berries, and foods to help the liver remove excess oestrogen.',
      color: Colors.orangeAccent,
    ),
    Stage(
      title: 'Autumn',
      description: 'Phase 4 (Days 20-28): Preparing for menstruation with a focus on rest.',
      biologically: 'The body is preparing to receive the fertilized egg and the inner wall of the uterus (the uterine lining) grows thicker, creating a nourishing place for it to grow into a human. If there isn’t an egg that’s been fertilized by sperm during ovulation phase, then there’s no need for the uterine lining, so it is released - that’s what your period is. ',
      emotionally: 'During autumn your oestrogen dips and progesterone begins to rise. Progesterone is a hormone which is all about slowing right down.You’ll start to feel quite sensitive and emotional during the final few days, and you might even notice that you have a few days where you get really angry or start crying for no reason.',
      physically: 'Lethargic and bloated with decreased energy. ou may notice you have less energy and you feel like there are only certain people (or sometimes no people) you want to be around. In the days before your period, you may also be feeling more sensitive and extra critical - to yourself and/or others. It’s a great time to find clarity though.',
      exercise: 'Yoga, gentle workouts, and meditation. Progesterone is also a “calming hormone”. It may increase sleep, but also can affect the way the brain picks up new skills. ',
      diet: 'Slow-burning carbs and fiber-rich foods, and lots of water. Going easy on caffeine will also help, I know it’s hard though! But if you’re feeling a bit anxious it’s definitely worth it for a few days.',
      color: Colors.pinkAccent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menstrual Cycle Stages'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.25,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: stages.length,
        itemBuilder: (context, index) {
          return StageCard(stage: stages[index]);
        },
      ),
    );
  }
}

class StageCard extends StatelessWidget {
  final Stage stage;

  StageCard({required this.stage});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: stage.color,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stage.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              stage.description,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(224, 255, 255, 255),
              ),
            ),
            SizedBox(height: 10),
             BulletedList(
                       bullet: Icon(
                       Icons.spa,
                       color: Color.fromARGB(255, 241, 133, 255),
                         ),
                        listItems: [
                          'Biologically:${stage.biologically}',
                          'Emotionally: ${stage.emotionally}',
                          'Physically: ${stage.physically}',
                          'Exercise: ${stage.exercise}',
                          'Diet: ${stage.diet}'
                          ], style: TextStyle(color: Colors.white, fontSize: 18) ,
                     ),

          ],
        ),
      ),
    );
  }
}

class Stage {
  final String title;
  final String description;
  final String biologically;
  final String emotionally;
  final String physically;
  final String exercise;
  final String diet;
  final Color color;

  Stage({
    required this.title,
    required this.description,
    required this.biologically,
    required this.emotionally,
    required this.physically,
    required this.exercise,
    required this.diet,
    required this.color,
  });
}
