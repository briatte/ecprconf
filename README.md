All raw data come from the [ECPR](https://ecpr.eu/) website archives of its [general conferences][gc] (GC) and [joint or research sessions][js] (JS/RS), for a total of 35 events:

- General conferences used to happen every odd year but have been yearly events since 2013. The data cover years 2011--2020, for a total of 9 conferences. All general conferences except for the 2020 one are structured through multiple-panel sections.

- Joint and research sessions are smaller, yearly events built around workshops (multiple-day panels). Both joint and research sessions were organised in years 2013--2016, always in different places. The data cover years 1999--2020, for a total of 22 joint sessions and 4 research sessions, but those have no papers listed.

- Despite the archives sometimes listing two different events in different places on the same year, each conference occurs only once per year. They all go back further in time than what we could retrieve in machine-readable format.

- In 2020, due to the COVID-19 pandemic, both the GC and JS events were organised as virtual, online events.

[gc]: https://ecpr.eu/Events/PastEventList.aspx?EventTypeID=2
[js]: https://ecpr.eu/Events/PastEventList.aspx?EventTypeID=4

# HOWTO

The panel lists used to find the panels and papers were downloaded manually on September 1, 2020. Everything else (panel and paper information) was downloaded and processed on that same day, using the first two scripts:

```r
source("01-download-pages.r")
source("02-extract-data.r")
```

The results are in the `data` folder, where the `.*-papers.tsv` files contain what we extracted from the panels and papers Web pages.

__No raw data are included in this repository,__ which means that you will not be able to replicate that first step, except by downloading it yourself.

Due to the absence of papers for the research sessions, we have data for __31 conferences__ instead of 35, totalling __25,004 papers__ from __4,355 panels__. Prior to data cleaning, we counted __16,058 authors__ and __2,853 affiliations__ overall.

Around 3.7% of all academic affiliations are missing. Missing affiliations for one event exceed 10% only for `gc-2011` (17%) and `js-2011` (28%).
