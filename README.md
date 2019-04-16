# Premature male mortality (15-49) in Mexican states, 1990-2015

> Kashnitsky, I., & Aburto, J. M. (forthcoming). Geofaceting: allign small-multiples for regions in a spatially meaningful way. Demographic Research. 



## Full text of the paper draft is available [here][text].

***

[![fig1][f1]][f1]  

***

[![fig2][f2]][f2]  

***

[![fig3][f3]][f3]  

***


To replicate the map, follow the instructions in "R/master-script.R" and, of course, feel free to explore in depth the chunks of code in "R" directory. 

If you have questions regarding the dataviz, feel free to contact me: ilya.kashnitsky@gmail.com. For quiestions on the Mexican data, contact Jose Manuel: jmaburto@health.sdu.dk.

Folow us on Twitter: [@ikahhnitsky][ik], [@jm_aburto][jma].

***

# Poster presented at PAA 2019

[![fig4][f4s]][f4]  

*Click for higher resolution image or get [PDF here][poster]*



[f1]: https://ikashnitsky.github.io/demres-geofacet/figures/gg-five-annotated.png
[f2]: https://ikashnitsky.github.io/demres-geofacet/figures/gg-nine.png
[f3]: https://ikashnitsky.github.io/demres-geofacet/figures/gg-tern-assamble.png
[f4]: https://ikashnitsky.github.io/demres-geofacet/poster-paa-2019/poster-paa-2019/geofacet-poster.png
[f4s]: https://ikashnitsky.github.io/demres-geofacet/poster-paa-2019/poster-paa-2019/geofacet-poster-small.png
[text]: https://doi.org/10.31219/osf.io/f49n6
[ik]: https://twitter.com/ikashnitsky
[jma]: https://twitter.com/jm_aburto
[poster]: https://ikashnitsky.github.io/demres-geofacet/poster-paa-2019/geofacet-poster.pdf

***


## REPLICATION. HOW TO
1. Fork this repository.
2. Using RStudio open "2018-geofacet-mexico.Rproj" file in the main project directory.
3. Run the "R/master_script.R" file. 
Wait. That's it.
The results are stored in the sub-directory "figures".

## LOGIC OF THE PROCESS
The whole process is split into three parts, which is reflected in the structure of R scripts. First, the steps required for reproducibility are taken. Second, all data manipulation steps are performed. Finally, the figures are built. 
The names of the scripts are quite indicative, and each script is reasonably commented. 


## SEE ALSO
 - [The initial version of the dataviz presented at Rostock Retreat Visualization in June 2017][retreat]
 - [Paper in _Health Affairs_ on homicides in Mexico][ha]
 - [Paper in _American Journal of Public Health_][ajph]
 - [Forthcoming paper in _The Lancet_ with an example of ternary colorcoding][lancet]


[arch]: https://ikashnitsky.github.io/doc/misc/demres-2018-geofacet.zip
[ha]: https://doi.org/10.1377/hlthaff.2015.0068
[ajph]: https://doi.org/10.2105/AJPH.2018.304878
[retreat]: https://github.com/ikashnitsky/geofaceted-premature-male-mortality-in-mexico
[lancet]: https://osf.io/zac5x/



## ACKNOWLEDGEMENT

The initial version of the data visualization presented in this paper was originally developed by Ilya Kashnitsky in team work with [Michael Boissonneault][mb], [Jorge Cimentada][jc], [Juan Galeano][jg], [Corina Huisman][ch], and [Nikola Sander][ns] during the dataviz challenge at [Rostock Retreat Visualization][rr] event in June 2017. IK thanks his team members for the unique experience of super productive brainstorming and enthusiastic teamwork. The creative dataviz challenge was developed by [Tim Riffe][tr] and [Sebastian Klüsener][sk], the organizers of [Rostock Retreat Visualization][rr].

[mb]: https://twitter.com/michaelboiss
[jc]: https://twitter.com/cimentadaj
[jg]: https://twitter.com/GEDEM_CED
[ch]: https://twitter.com/CorinaHuisman
[ns]: https://twitter.com/nikolasander
[tr]: https://twitter.com/timriffe1
[sk]: https://twitter.com/demomapper
[rr]: https://www.rostock-retreat.org/2017/




