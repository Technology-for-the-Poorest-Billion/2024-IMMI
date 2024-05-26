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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
        children: [
          Text('The Stages of the Menstrual Cycle', style:  DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0)),
          Text('Your menstrual cycle is every day of your life (until menapause!) so it’s important to track it. Each day, something different is happening so that’s why you’ll feel different during different phases of your cycle. We can break your cycle into 4 parts, it’s easy to understand them if you think about it like the Seasons. '),
          Text('Gap', style: TextStyle(color: Colors.white.withOpacity(0), fontSize:12)),
          Text('Winter', style: TextStyle(color: Colors.black.withOpacity(1), fontSize:18) ),
          Text('This is Phase 1 of your cycle and usually lasts from day 1-6 but this can vary. It’s the phase when you’re on your period (bleeding) and it’s the time to rest, like you’re hibernating in winter! ', textAlign: TextAlign.left),
          Text('Gap', style: TextStyle(color: Colors.white.withOpacity(0), fontSize:4)),
          BulletedList(
            bullet: Icon(
              Icons.ac_unit,
              color: Colors.pink,
              ),
              listItems: [
                      'Biologically -''what’s happening is that your uterus is shedding the lining that would have held the egg if it was fertilised. This lining has built up throughout the month and your body is now working hard to release the blood in the lining of your uterus, so it’s sending you all the signals to slow down and stop while it’s busy! ',
                      'Emotionally - you’re going to be feeling sensitive, tired and also like you can let go of everything. It’s like a physical and emotional release when your period comes, all the emotions can fly away too and tension can be released! You can take this time to really nurture yourself, get lots of sleep and even wear nice big warm jumpers.',
                      'Physically - you might feel some pain so cancel all social engagements and rest, rest, rest. Taking this downtime now will set you up for the rest of your cycle. If you don’t slow down, you may end up running on empty later which can make your PMS really intense.',
                      'Exercise - Gentle is the name of the game here - Light exercise can really help, especially if you are experiencing pain, so take time to go on gentle walks or do some light stretching. After a few days of bleeding you might feel energised so don’t hold back from an easy run if your body wants that. ',
                      'Diet - Up your iron! Think about granola for breakfast, chicken sandwiches for lunch and even some red meat or nice tofu dish for dinner with lots of leafy greens or tomatoes to help the iron absorb. Snacks like raisins and dried apricots are good too, and some orange juice. '
                    ], style:TextStyle(color: Color.fromARGB(255, 65, 64, 64).withOpacity(1), fontSize:11) ,
          ),
          Text('Gap', style: TextStyle(color: Colors.white.withOpacity(0), fontSize:10)),
          Text('Spring', style: TextStyle(color: Colors.black.withOpacity(1), fontSize:18) ),
          Text('This is the second phase of your cycle, when your period has finished, and before you ovulate. It usually lasts from days 7-13 but this can vary. ', textAlign: TextAlign.left),
          Text('Gap', style: TextStyle(color: Colors.white.withOpacity(0), fontSize:4)),
          BulletedList(
            bullet: Icon(
              Icons.spa,
              color: Colors.pink,
              ),
              listItems: [
                      'Biologically - what’s happening is your egg is preparing to be released. The egg leaves the ovary and travels down the fallopian tube towards the uterus. During this journey the egg will meet the sperm (if there is sperm present) and get fertilized to produce pregnancy. ',
                      'Emotionally - your hormone levels are starting to rise and you’ll be feeling more energetic, just like you’re coming out of hibernation in spring. Our oestrogen levels start to rise and we start to feel more energy, more motivation and full of hope, optimism and ideas.',
                      'Physically - you’ll be ready to exercise again, and that side hustle you’ve been thinking about - start getting it down on paper. Your creative juices are starting to flow so make the most of it. Meet up with friends, socialise and feel the energy!',
                      'Exercise - it’s a great time to work out at high intensity, potentially incorporating regular home workouts, or frequent walks at your local park or trips to the gym - whatever is suited to you & what you like. Pre-ovulation, your body temperature stays consistent, pain tolerance increases and the ability to digest and utilise carbohydrates is more efficient. So, in other words, go out and shift some steel and hit those personal bests! Be careful though as your ligaments and tendons are a bit more relaxed thanks to oestrogen, so don’t overstretch or do too much flexibility work during this phase as you might pull a muscle or twist an ankle or something! ',
                      'Diet - Salads with broccoli, salmon, avocados are great here - a sprinkle of superfoods, and it’s also important to have fermented foods which help with your gut health. This might be pickles or yoghurt. Nuts are a great snack also - you may consider these during your working day to remain energised and focused! '
                    ], style:TextStyle(color: Color.fromARGB(255, 65, 64, 64).withOpacity(1), fontSize:11) ,
          ),
        
        ],
        
      ),
      );
  
  }
}
