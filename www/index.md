---
title: IMMI Period Tracker Information
---

## Introduction
IMMI helps to manage and educate about your menstrual cycle by creating an informative website in which you can track your period.
We will run you through how to use the website, how the website was put together and why this website is needed and a useful tool.

## Why the Website is needed
There's a lack of education about the menstrual cycle around the world with statistics showing that 40% of girls feel "confused and unprepared" when they 
first get their period. Current tools that provide assistance to help educate and track cycles exhibit negligence towards data privicy despite 79% of women
expressing concern. The IMMI Period Tracker has been developed with this in mind as well as a heavier emphasis on educating about the menstual cycle.

### Benefits of the IMMI Period Tracker
#### Health Education and Awareness Benefits:
- Users gain a better insight into understanding their menstrual cycles.
- Tracking your information helps recognise symptoms and how they change with the different phases of your cycle.
- Offers educational resources that may not be accessible to all.
- Can be used as a teaching tool in schools to educate about menstrual health.

#### Data Security and Data Driven Health Information Benefits:
- Users have control over their data where the their information is only accessed by them.
- Data is accumulated over a long time increasing the accuracy of pattern recognition 
- Long term data collection is valuable when tracking overall reproductive health trends.

#### Customisation Benefits:
- Users can adjust the settings to their preference.
- Trailered recommendations can be given from the user data if the user wants.
- There can be a customisation of tracking features to suit individual needs.

#### Personal Benefits:
- The website can provide a sense of community which can minimise the feeling of isolation with menstrual health.
- Understanding your cycle can reduce stress when managing life around your period.
- Tracking your period can help reduce anxiety about unexpected periods.
- Having a safe space to track your information can also reduce stress and anxiety when thinking about your menstrual cycle.


## How to use the IMMI Period Tracker
We have a step-by-step demonstration of the main functions of the website.
This can be found at this [link](appLayout.md) to the website layout page.


## How the Tracker was developed
The website was developed by 






### To configure your website:

- The required files to run a basic website are included in the repository. We use here Jekyll to turn markdown files into html that will be automatically updated on the website. The component responsible for this is a GitHub action, which is specified in the folder .github/workflows. There is no need to change this file. However:

- In the settings of your repository, go the section "Pages", and select GitHub Actions in the drop down menu to indicate that this is the way you'd like the webpage to be generated.

- Each time you update the markdown files in the www folder of the repository, it will regenerate the web content. The address of the website will be:

```
https://technology-for-the-poorest-billion.github.io/[your repo name here]
```

- index.md is the root of your website. To link another page from here, located within the www folder, use the following syntax:

```
This is a [link](linkedpage.md) to interesting content.
```

Which results in:

This is a [link](Period Tracker.html) to interesting content.

- Pay attention to the header of the markdown files in this section. It contains a title section that you will need to reproduce for each page to render them properly.


