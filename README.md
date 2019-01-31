# HIV Pain (HIP) Intervention Study

## Bibliometric information
Parker R, Madden VJ, Devan D, Cameron S, Jackson K, Kamerman P, Reardon C, Wadley A. Barriers to implementing clinical trials on non-pharmacological treatments in developing countries – lessons learnt from addressing pain in HIV. _Pain Reports_ \[submitted 2019-01-31\]

## Abstract
**Introduction:** Pain affects over half of people living with HIV/AIDS (LWHA) and pharmacological treatment has limited efficacy. Preliminary evidence supports non-pharmacological interventions.  We previously piloted a multimodal intervention in amaXhosa women LWHA and chronic pain in South Africa with improvements seen in all outcomes, in both intervention and control groups.  
**Method:** A multicentre, single-blind randomised controlled trial with 160 participants recruited was conducted  to determine whether the multimodal peer-led intervention reduced pain in different populations of both male and female South Africans LWHA. Participants were followed up at Weeks 4, 8, 12, 24 and 48 to evaluate effects on the primary outcome of pain, and on depression, self-efficacy and health-related quality of life.  
**Results:** We were unable to assess the efficacy of the intervention due to a 58% loss to follow up (LTFU). Secondary analysis of the LTFU found that sociocultural factors were not predictive of LTFU. Depression, however, did associate with LTFU, with greater severity of depressive symptoms predicting LTFU at week 8 (p=0.01).  
**Discussion:** We were unable to evaluate the effectiveness of the intervention due to the high LTFU and the risk of retention bias.  The different sociocultural context in South Africa may warrant a different approach to interventions for pain in HIV compared to resource-rich countries, including a concurrent strategy to address barriers to health care service delivery. We suggest that assessment of pain and depression need to occur simultaneously in those with pain in HIV. We suggest investigation of the effect of social inclusion on pain and depression. 

## Analysis outputs

**The data required to run the scripts have not been included in the repo because study participants did not consent to public release of their data. However, the data are available on request from Tory Madden (torymadden@gmail.com) or Peter Kamerman (peter.kamerman@gmail.com), or by submitting an [issue](https://github.com/kamermanpr/HIP-study/issues).**

The outputs from all analysis scripts are located in the _/outputs_ directory. The outputs are formatted as markdown and html. The markdown documents are intermediate outputs generated during the production of the html documents, and while they allow quick browsing of the analysis outputs on GitHub, MathJax formulae and tables are not formatted. 

## Run the analysis scripts

The image is built using the [_rocker/verse_](https://hub.docker.com/r/rocker/verse/) image of [_base R_](https://cran.r-project.org/) _v3.5.2_, and includes [_RStudio server_](https://www.rstudio.com/products/rstudio/#Server), the [_TinyTex_](https://yihui.name/tinytex/) Latex distribution, the [_tidyverse_](https://www.tidyverse.org/) suite of R packages (with dependencies), and several R packages (with dependencies) that are required to run the markdown scripts in [_HIP-study_](https://github.com/kamermanpr/HIP-study.git). CRAN packages were installed from [MRAN](https://mran.microsoft.com/timemachine) using the lasted package releases at the time the image was generated.

### Details
- **OS:**  
    - Debian:stretch
- **R:**  
    - v3.5.2 
- **RStudio server:**  
    - v1.1.456 
- **MRAN packages:**  
    - tidyverse
    - knitr
    - magrittr
    - skimr
    - broom
- **LaTex:**   
    - TinyTex

### Using Docker to run the HIP-study analysis

You need to have Docker installed on your computer. To do so, go to [docker.com](https://www.docker.com/community-edition#/download) and follow the instructions for downloading and installing Docker for your operating system. Once Docker has been installed, follow the steps below, noting that Docker commands are entered in a terminal window (Linux and OSX/macOS) or command prompt window (Windows). Windows users also may wish to install [_GNU Make_](http://gnuwin32.sourceforge.net/downlinks/make.php) (required for the `make` method of running the scripts) and [_Git_](https://gitforwindows.org/) version control software (not essential). 

#### Download the latest image

Enter: `docker pull kamermanpr/docker-hip-study:v1.0.0`

#### Run the container

Enter: `docker run -d -p 8787:8787 -v </PATH>:/home/rstudio --name threshold -e USER=hip -e PASSWORD=study kamermanpr/docker-hip-study:v1.0.0`

Where `</PATH>` refers to the path to the HIP-study directory on your computer, which you either cloned from GitHub ([_kamermanpr/HIP-study_](https://github.com/kamermanpr/HIP-study.git), `git clone https://github.com/kamermanpr/HIP-study`), or downloaded and extracted from figshare ([DOI: 10.6084/m9.figshare.7654637](https://doi.org/10.6084/m9.figshare.7654637)).

If you use _git_ you can preconfigure the docker image with your _git_ credentials: `docker run -d -p 8787:8787 -v </PATH>:/home/rstudio --name hip -e USER=hip -e PASSWORD=study -e GIT_USER="<your name>" -e GIT_EMAIL="<your email address>" kamermanpr/docker-hip-study:v1.0.0`

#### Login to RStudio Server

- Open a web browser window and navigate to: `localhost:8787`

- Use the following login credentials: 
    - Username: _hip_	
    - Password: _study_
    
#### Prepare the HIP-study directory

The HIP-study directory comes with the outputs for all the analysis scripts in the _/outputs_ directory (_html_ and *md* formats). However, should you wish to run the scripts yourself, there are several preparatory steps that are required:  

1. Acquire the data. The data required to run the scripts have not been included in the repo because participants in the studies did not consent to public release of their data. However, the data are available on request from Peter Kamerman (peter.kamerman@gmail.com). Once the data have been obtained, the files should be copied into a subdirectory named _/data-original_.

2. Clean the _/outputs_ directory by entering `make clean` in the _Terminal_ tab in RStudio.

#### Run the HIP-study analysis scripts

To run all the scripts (including the data cleaning scripts), enter `make all` in the _Terminal_ tab in RStudio. 

To run individual RMarkdown scripts (_\*.Rmd_ files)

1. Generate the cleaned data using one of the following methods:  
    - Enter `make data-cleaned/demographics.rds` in the _Terminal_ tab in RStudio.  
    - Enter `source('clean-data-script.R')` in the _Console_ tab in RStudio.  
    - Open the _clean-data-script.R_ script through the _File_ tab in RStudio, and then click the **'Source'** button on the right of the _Script_ console in RStudio for each script.
    
2. Run the individual script by:  
    - Entering `make outputs/<NAME_OF_INPUT_FILE>.html` in the _Terminal_ tab in RStudio, **OR**
    - Opening the relevant _\*.Rmd_ file through the _File_ tab in RStudio, and then clicking the **'knit'** button on the left of the _Script_ console in RStudio. 

#### Shutting down

Once done, log out of RStudio Server and enter the following into a terminal to stop the Docker container: `docker stop hip`. If you then want to remove the container, enter: `docker rm threshold`. If you also want to remove the Docker image you downloaded, enter: `docker rmi kamermanpr/docker-hip-study:v1.0.0`

