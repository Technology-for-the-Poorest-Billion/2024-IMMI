import 'package:flutter/material.dart';
import 'app_localizations.dart';

class InfoPage extends StatelessWidget {

  // get child => null;
  
  @override
  Widget build(BuildContext context) {
    // Determine text color based on theme
    Color textColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('info_title') ?? 'Information'),
        backgroundColor: Color.fromARGB(255, 255, 217, 187),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TitleSection(
              infotitle: 'infotitle',
              infoDescription: 'infoDescription',
              textColor: textColor,
            ),
            Container(
            child: GridView.count(
              shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: [
                  StageCard(
                    title: 'stage1',
                    subtitle: 'stage1Description',
                    bio: 'bio1',
                    emo: 'emo1',
                    phys: 'phys1',
                    ex: 'ex1',
                    diet: 'diet1',
                    backgroundColor:  Color(0xFFFFCDD2),
                    textColor: textColor,
                  ),
              StageCard(
                    title: 'stage2',
                    subtitle: 'stage2Description',
                    bio: 'bio2',
                    emo: 'emo2',
                    phys: 'phys2',
                    ex: 'ex2',
                    diet: 'diet2',
                    backgroundColor: Color(0xFFC8E6C9),
                    textColor: textColor,
                  ),  
              StageCard(
                    title: 'stage3',
                    subtitle: 'stage3Description',
                    bio: 'bio3',
                    emo: 'emo3',
                    phys: 'phys3',
                    ex: 'ex3',
                    diet: 'diet3',
                    backgroundColor: Color(0xFFBBDEFB),
                    textColor: textColor,
                  ),  
              StageCard(
                    title: 'stage4',
                    subtitle: 'stage4Description',
                    bio: 'bio4',
                    emo: 'emo4',
                    phys: 'phys4',
                    ex: 'ex4',
                    diet: 'diet4',
                    backgroundColor: Color(0xFFFFF9C4),
                    textColor: textColor,
                  ), 
                ],
            ),
            ), 
 
            AdditionalSection(
                      adTitle: 'AdditionTitle',
                      adDescription: 'AdditionDescription',
                      Cramps: 'Cramps',
                      Breakouts: 'Breakouts',
                      TB: 'TB',
                      Fatigue: 'Fatigue',
                      Bloating: 'Bloating',
                      backgroundColor: Color(0xFFE1BEE7),
                      textColor: textColor,
                  ),
            AdditionalSectionAbout(
                  Abouttitle: 'AboutTitle',
                  Aboutdescription: 'AboutDescription',
                  backgroundColor: Color(0xFFE0F7FA),
                  textColor: textColor,
              ),
            
            FaqTitleSection(FAQTitle: 'FAQTitle', textColor: textColor),
            FaqSection(question: 'q1', answer: 'a1', textColor: textColor), 
            FaqSection(question: 'q2', answer: 'a2', textColor: textColor),
            FaqSection(question: 'q3', answer: 'a3', textColor: textColor),
            FaqSection(question: 'q4', answer: 'a4', textColor: textColor),
            FaqSection(question: 'q5', answer: 'a5', textColor: textColor),
            FaqSection(question: 'q6', answer: 'a6', textColor: textColor),
            FaqSection(question: 'q7', answer: 'a7', textColor: textColor),
            FaqSection(question: 'q8', answer: 'a8', textColor: textColor),
            FaqSection(question: 'q9', answer: 'a9', textColor: textColor),
          ]
                    ),
              ),
            );
  }
}

class TitleSection extends StatelessWidget {
  final String infotitle;
  final String infoDescription;
  final Color textColor;  // Add textColor
  
TitleSection({
    required this.infotitle,
    required this.infoDescription,
    required this.textColor,  // Require textColor in constructor
});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 16.0),
          Text(
            AppLocalizations.of(context)!.translate(infotitle) ?? infotitle,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: textColor),
          ),
          SizedBox(height: 8.0),
          Text(
            AppLocalizations.of(context)!.translate(infoDescription) ?? infoDescription,
            style: TextStyle(fontSize: 16.0, color: textColor),
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
  final String bio;
  final String emo;
  final String phys;
  final String ex;
  final String diet;
  final Color backgroundColor;
  final Color textColor;  // Add textColor

  StageCard({
    required this.title,
    required this.subtitle,
    required this.bio,
    required this.emo,
    required this.phys,
    required this.ex,
    required this.diet,
    required this.backgroundColor, 
    required this.textColor,  // Require textColor in constructor
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
              AppLocalizations.of(context)!.translate(title) ?? title,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: textColor),
            ),
            SizedBox(height: 6.0),
            Text(
              AppLocalizations.of(context)!.translate(subtitle) ?? subtitle,
              style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic, color: textColor),
            ),
            SizedBox(height: 5.0),
            Text(
              AppLocalizations.of(context)!.translate(bio) ?? bio,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            SizedBox(height: 5.0),
            Text(
              AppLocalizations.of(context)!.translate(emo) ?? emo,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            SizedBox(height: 5.0),
            Text(
              AppLocalizations.of(context)!.translate(phys) ?? phys,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            SizedBox(height: 5.0),
            Text(
              AppLocalizations.of(context)!.translate(ex) ?? ex,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            SizedBox(height: 5.0),
            Text(
              AppLocalizations.of(context)!.translate(diet) ?? diet,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
          ]
              ),
            ),
          
        );
  }
}

class AdditionalSection extends StatelessWidget {
  final String adTitle;
  final String adDescription;
  final String Cramps;
  final String Breakouts;
  final String TB;
  final String Fatigue;
  final String Bloating;
  final Color backgroundColor;
  final Color textColor;

  AdditionalSection({
    required this.adTitle,
    required this.adDescription,
    required this.Cramps,
    required this.Breakouts,
    required this.TB,
    required this.Fatigue,
    required this.Bloating,
    required this.backgroundColor,
    required this.textColor,
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
              AppLocalizations.of(context)!.translate(adTitle) ?? adTitle,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
              Text(
              AppLocalizations.of(context)!.translate(adDescription) ?? adDescription,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            SizedBox(height: 5.0),
            Text(
              AppLocalizations.of(context)!.translate(Cramps) ?? Cramps,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            SizedBox(height: 5.0),
            Text(
              AppLocalizations.of(context)!.translate(Breakouts) ?? Breakouts,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            SizedBox(height: 5.0),
            Text(
              AppLocalizations.of(context)!.translate(TB) ?? TB,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            SizedBox(height: 5.0),
            Text(
              AppLocalizations.of(context)!.translate(Fatigue) ?? Fatigue,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            SizedBox(height: 5.0),
            Text(
              AppLocalizations.of(context)!.translate(Bloating) ?? Bloating,
              style: TextStyle(fontSize: 14, color: textColor),
            ),    
          ],
        ),
      ),
    );
  }
}

class AdditionalSectionAbout extends StatelessWidget {
  final String Abouttitle;
  final String Aboutdescription;
  final Color backgroundColor;
  final Color textColor;

  AdditionalSectionAbout({
    required this.Abouttitle,
    required this.Aboutdescription,
    required this.backgroundColor,
    required this.textColor,
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
              AppLocalizations.of(context)!.translate(Abouttitle) ?? Abouttitle,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
          Text(AppLocalizations.of(context)!.translate(Aboutdescription) ?? Aboutdescription,
           style: const TextStyle(fontSize: 14.0)),

          ],
        ),
      ),
    );
  }
}

class FaqTitleSection extends StatelessWidget {
  final String FAQTitle;
  final Color textColor;

  FaqTitleSection({
  required this.FAQTitle,
  required this.textColor,
  });

   @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 14.0),
        Text(
          AppLocalizations.of(context)!.translate(FAQTitle) ?? FAQTitle,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: textColor),
        ),
      ],
    );
  }
}

class FaqSection extends StatelessWidget {
  final String question;
  final String answer;
  final Color textColor;

FaqSection({
  required this.question,
  required this.answer,
  required this.textColor,
  });  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4.0),
          Card(
            child: ExpansionTile(
              title: Text(AppLocalizations.of(context)!.translate(question) ?? question,
               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: textColor)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(AppLocalizations.of(context)!.translate(answer) ?? answer,
                  style: TextStyle(fontSize: 14.0, color: textColor)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
