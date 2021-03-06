# Starting off by loading all my libraries

library(shiny)
library(shiny)
library(shinythemes)
library(leaflet)
library(wordcloud)
library(tm)
library(wordcloud2)
library(gganimate)
library(broom.mixed)
library(gtsummary)
library(rstanarm)
library(markdown)
library(Rcpp)

# In general my strategy for formatting was: Use fluidRow, alternate which
# side had plot/tables and which side had text among the rows, and put two 
# breaks between every row to keep things from looking cluttered.

# Starting off with a navbar Page so that I can get my five main tabs

ui <- navbarPage("The Impact of Coronavirus On Arts Organizations",
                 
                 # My first tab will allow users to explore survey demographics
                 # This is also the default tab, which is good, since it's 
                 # colorful
                 
                 tabPanel("Explore Survey Demographics",
                          
                          # fluidPage allows for for the possibility of 
                          # fluidRows, which I basically used to nicely format
                          # my entire project. It lets you pick how much space
                          # an element takes up within a row as long as the 
                          # total amount of space taken up by elements in the 
                          # row adds to 12
                          
                          fluidPage(
                            titlePanel("Explore Survey Demographics"),
                                    h3("Background and Motivations"),
                            
                            # Here's some general background on the project.
                            # It shoould be the first thing the user reads
                            
                                    p("In March 2020, Americans for the Arts, the nation’s 
                                    largest arts advocacy organization, launched a 
                                    survey measuring the Economic Impact of Coronavirus 
                                    on the Arts and Culture Sector. 
                                    Since then, more than 
                                    17,000 artists and arts organizations have 
                                    responded to the survey, 
                                    providing firsthand insight into a sector 
                                    that has been especially hard hit by the 
                                    economic downturn of the COVID-19 pandemic. 
                                    This project will aim to explore the results 
                                    of that survey, investigating how COVID-19 
                                    has impacted the economic landscape of 
                                      arts organizations around the nation."),
                                    br(),
                                    br(),
                            
                            # This row has the lollipop plot that allows the
                            # user to see when the survey was completed
                            
                                    fluidRow(
                                      column(5, 
                                             h3("When was the survey completed?"),
                                             p("Americans for the Arts first opened their 
                                               COVID-19 impact survey on March 13th, 2020, 
                                               right as a wave of lockdowns, closures, and 
                                               stay-at-home orders swept the nation. While 
                                               the survey has continued to be open up until the 
                                               present, the bulk of responses are from March through May,
                                               with a few spikes where the survey was re-publicized 
                                               en masse.  
                                               This is important to keep in mind during analysis, as
                                               many reports of lost revenue pertain only to the amount 
                                               that an organization had lost within the first month or 
                                               so of the pandemic. Use the slider below to explore 
                                                 how many survey responses were garnered in a particular span of time."),
                                             
                                             
                                             # This slider allows the user to 
                                             # pick the dates for the lollipop
                                             # plot. The minimum and maximum 
                                             # are the first and last days I had
                                             # survey data for. Everything 
                                             # had to be specified as a date and 
                                             # given the format "%Y-%m-%d"
                                             
                                             sliderInput("dates", "Choose a Range of Dates",
                                                         min = as.Date("2020-03-13", "%Y-%m-%d"),
                                                         max = as.Date("2020-09-02", "%Y-%m-%d"), 
                                                         value = c(as.Date("2020-03-13", timeFormat = "%Y-%m-%d"),
                                                                   as.Date("2020-09-02", "%Y-%m-%d")))),
                                      
                                      # This is the output for the lollipop plot
                                      
                                      column(7, 
                                             plotOutput("num_org"))
                                    ),
                                    br(),
                                    br(),
                            
                            # This next section allows users to explore what types of organizations answered the survey
                            # It also has my treemap
                
    
                            
                                    fluidRow(
                                      column(7, 
                                             plotOutput("plot2")),
                                      column(5, 
                                             h3("What types of organizations answered the survey?"),
                                             p("When most people hear the words “arts organizations,” they 
                                                 likely think of theaters, galleries, or museums. While these 
                                                 are important parts of the sector, arts organizations also 
                                                 encompass places like local, state and regional agencies that 
                                                 provide networking and financial support, media arts 
                                                 organizations, and community arts centers. Explore what 
                                                 the breakdown of organizations who answered the survey looked like in your state"),
                                             
                                            # This is a drop down menu that allows users to choose their state
                                             
                                             selectInput("var2", "State", c("Alaska", "Arizona", "Arkansas", 
                                                                            "California", "Colorado", "Connecticut",
                                                                            "Florida", "Georgia", "Hawaii", 
                                                                            "Idaho", "Illinois", "Indiana",
                                                                            "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", 
                                                                            "Massachusetts", "Michigan", 
                                                                            "Minnesota", "Mississippi", "Missouri", 
                                                                            "Montana", "Nebraska", 
                                                                            "Nevada", "New Hampshire", "New Jersey", "New Mexico",
                                                                            "New York", "North Carolina", 
                                                                            "North Dakota", "Ohio", 
                                                                            "Oklahoma", "Oregon", "Pennsylvania",
                                                                            "Rhode Island", "South Carolina", 
                                                                            "South Dakota", "Tennessee", 
                                                                            "Texas", "Utah", "Vermont",
                                                                            "Virginia", "West Virginia", 
                                                                            "Washington", "Wisconsin")))
                                    ),
                                    br(),
                                    br(),
                            
                            
                            # This next row allows users to explore what size and purpose of organization answered
                            # the survey. It just has one plot and some text
                            
                                    fluidRow(
                                      
                                      column(4, 
                                             h3("What size of organization answered the survey?"),
                                             p("Arts organizations come in all sizes. While the majority of 
                                                 survey respondents were small nonprofits, several larger organizations
                                                 with self-reported annual budgets of upwards of $10 million responded
                                                 as well. Though they might not suffer the same risks of complete closure 
                                                 like smaller organizations do, these larger organizations also faced major
                                                 financial barriers due to the pandemic, as we will later explore.")),
                                      column(8, 
                                             br(),
                                             
                                             # This is the barplot that has number of organizations by budget and 
                                             # filled by legal status
                                             
                                             plotOutput("plot1"))
                                    ),
                                    br(),
                                    br(),
                            
                            
                            # This last part of the page has an interactive map
                            
                                    h3("Where were responses from?"),
                                    p("Responses to the coronavirus impact survey came from all over the nation.
                                      Explore the map below to see how many organizations responded in each zip code."),
                            
                            # Have to use leafletOutput here
                            
                                    leafletOutput("map")
                          )),
                 
                 
                 # My second panel is the modeling because this is the crux of
                 # my project
                 
                 tabPanel("Modeling Lost Revenue",
                          
                          # Here's a general intro to building the model
                          
                          h2("The Task: Building a Model to Predict Revenue Loss"),
                          p("Understanding the amount of revenue that organizations have lost 
                            due to the pandemic is crucial in formulating relief measures that properly
                            address the needs of artists and arts organizations. The following page
                            considers several different models for predicting the amount of revenue
                            loss for an organization with an annual budget of between $100,000 and 
                            $249,000."),
                          br(),
                          br(),
                          
                          # This section explains why I chose to focus on smaller
                          # organizations, with a plot showing that these types
                          # of organizations are least likely to survive the
                          # pandemic to help back up my decision
                          
                          fluidRow(
                            column(5, 
                                   h3("Focusing on Smaller Organizations: Rationale"),
                                   p("As shown on the previous page, organizational budgets ranged 
                            from all volunteer to upwards of $10 million, resulting in a large range
                            of organizational revenue loss. 
                            For the purposes of building a model, I chose to focus on 
                            organizations with self-reported annual budgets of $100,000 
                            to $249,000 for several reasons. Firstly, budget was reported 
                            in broad categories rather than a continuous numerical variable, 
                            and there is less variation within categories for organizations 
                            of smaller budgets (this means that there will be less variation 
                            that occurs outside of the model). Furthermore, this was the 
                            second most common category, after organizations with an annual 
                            budget of less than $100,000, a category that I feared would be 
                            a confusing mix of individuals and organizations. Finally, as 
                            shown in the plots to the right, organizations of this size felt 
                            the least likely that they would survive the pandemic, 
                            suggesting a particular need for models to understand 
                            more about how much they were losing and what could be done to help.")),
                            column(7, 
                                   br(), 
                                   
                                   # And here's the plot, created in the server
                                   
                                   plotOutput("survival_budget"))),
                          br(),
                          br(),
                          
                          # This next section explains my three original models, along with
                          # a table that shows the variables in each
                          
                          fluidRow(
                            column(9, 
                                   tableOutput("var_table")),
                            column(3, 
                            h3("Model Building Process"), 
                            p("Initially, I constructed three different models to predict lost
                                                                      revenue for small arts organizations with three levels
                                                                      of complexity. The simplest model used only one continuous 
                                                                      variable, the number of lost attendees. The medium model incorporated
                                                                      a factor variable for the type of organization, based on my hypothesis
                                                                      that front-facing organizations such as museums or galleries might have
                                                                      more to lose in the pandemic than networking organizations, such as 
                                                                      state arts agencies. The third and most complex model considered several
                                                                      additional variables that I thought could also indicate greater lost revenue
                                                                      for an organization; whether they had cancelled events, whether they had
                                                                      closed their business, 
                                                                      and the amount of money they had spent on unexpected new expenditures."))
                            
                          ),
                          br(),
                          br(),
                          fluidRow(
                            
                            # This row explains how I selected the models and shows a corresponding table
                            
                            column(8, 
                                   h3("Model Selection"),
                                   p("As shown, the medium complexity model had the smallest RMSE,
                                     in cross validation, but it was not significantly different 
                                     enough from the simple model that would indicate the extra 
                                     complexity was worthwhile."),
                                   br(),
                                   p("Why might these more complex models have been less effective at predicting
                                     lost revenue? I think some of it may have had to do with the high variation
                                     in factors unexplained by any of the models; namely, how exactly the survey respondents
                                     estimating lost revenue. Survey participants were asked to 'Estimate 
                                     how much your organization's revenue  has decreased as a result of the coronavirus?', but
                                     it is possible that some people may have either provided an incorrect estimate or
                                     inadvertently included ambiguous events (i.e. do you count a concert that was scheduled
                                     for the future but will likely be canceled as lost revenue?). Furthermore, while I limited
                                     the survey response dates for this analysis from March 13th to June 1st in order to decrease
                                     the impact of time as a variable, one would expect an overall increase in lost revenue over even
                                     this short span of time (ultimately, I chose not to include time in the model due to the high 
                                     variation in number of responses per day). Because the number of lost attendees naturally
                                     matches with the span of time/method by which individual organizations calculated their lost revenue,
                                     it makes sense that it works effectively as a predictor on its own.")),
                            column(4, 
                                   tableOutput("models_table"))),
                          br(),
                          br(),
                          
                          # This row has a table and interpretation for my final model
                          
                          fluidRow(
                            column(7, 
                                   h3("Interpreting the Final Model"),
                                   p("The median of the posterior distribution of estimated revenue 
                                     loss for an organization with 0 lost attendees is $29,220.80, 
                                     suggesting that the pandemic has had a severe economic impact 
                                     on non-presenter arts organizations. For every additional lost 
                                     attendee, the predicted revenue loss to small arts organizations 
                                     is $1.45 (95% confidence interval: $1.24 to $1.65). The median 
                                     of the posterior distribution for sigma, the true standard 
                                     deviation of the lost revenue of small arts organizations, is 
                                     $31,490, suggesting that there is great variation, with some 
                                     organizations losing next to nothing and others losing over 50% 
                                     of their annual budget (note that this only takes into account the March-May timeframe).")),
                            column(4, 
                                   offset = 1, 
                                   tableOutput("final_mod"))),
                          br(),
                          br(),
                          
                          # This row has my lovely histogram that predicts lost 
                          # revenue for individual and average organizations based 
                          # on lost attendees
                          
                          fluidRow(
                            column(8, 
                                   plotOutput("pred_plot")),
                            column(4, 
                                   h3("Predicting Revenue Loss"),
                                   p("Use the slider below to make predictions about how much
                                     an organization of a budget between $100,000 and $249,000 
                                     with a certain number of lost attendees may have lost in revenue
                                     during the first few months of the pandemic."),
                                   
                                   # This slider allows the user to choose the number
                                   # of lost attendees. It starts at 0 and
                                   # the user can choose from there in increments
                                   # of 200
                                   
                                   sliderInput("attendees", "Number of Attendees",
                                               min = 0, max = 40000,
                                               value = 0, step = 200)))),
                 
                 # This panel situates my findings within broader unemployment
                 # and health trends
                 
                 tabPanel("In Dialogue with the Pandemic",
                          h2("Contextualizing the Economic Impact of COVID-19 on Arts Organizations"),
                          p("COVID-19 had an intense economic impact on arts organizations.
                            In our model, we explored the lost revenue in small organizations, which tended to be in the tens of thousands. 
                            Americans for the Arts estimates over $1,700,000,000 in economic damage to arts organizations that have responded to the survey to date (their data is about 2 months more recent than the data analyzed in this project).
                            Unsurprisingly, this has caused many organizations to struggle to pay their workers 33% of organizations surveyed laid off or furloughed artists or creative workforce members, and 35% have reduced salaries and payroll.
                            How have these metrics compare to organizations in non-arts sectors? 
                            Is the degree of economic damage the same around the nation? 
                            These are big questions that merit further analysis, but this page will begin to tackle them, situating the economic impact of COVID-19 on arts organizations within the broader context of the pandemic."),
                          
                          br(),
                          br(),
                          # This row shows how cases didn't seem to have much of an
                          # impact on financial wellbeing of arts organizations
                          
                          fluidRow(
                            column(8, 
                                   
                                   # Within this tab, there's a baby tab that
                                   # lets you choose which of the three graphs 
                                   # you want to see
                                   
                                   tabsetPanel(
                              tabPanel("Severity Financial Impact", 
                                       plotOutput("states_1")), 
                              tabPanel("Likelihood Staff Reduction", 
                                       plotOutput("states_2")), 
                              tabPanel("Chances of Survival", 
                                       plotOutput("states_3")))
                            ),
                            
                            # This text explains that
                            
                            column(4, 
                                   h3("How did statewide case numbers affect arts organizations?"),
                                   p("Did arts organizations around the nation feel the effects
                                   of the pandemic similarly? The answer seems to be yes (at least
                                   for the March-May timeframe, which is what's shown in the plot).
                                   Despite some states
                                   having much higher rates of COVID-19, arts organizations with
                                   budgets between $100,000 and $249,999 (the same sub-group predicted
                                   in the model) self-rated the economic damage done to their organizations
                                   at similar levels around the nation; even organizations
                                   in NY, a state
                                   which is not shown on this plot because 
                                   its COVID-19 rates were a high outlier for 
                                   this time period, had about average ratings
                                   of financial impact. This
                                   lack of an obvious relationship between statewide COVID-19 case rates and 
                                   economic impact on arts organizations, as shown by the nearly flat trendline,
                                   suggests that programs at the national level could be an effective
                                   way to address this widespread economic hardship."))),
                          
                          # This row contains some unemployment background
                          # and my animation
                          br(),
                          br(),
                          
                          fluidRow(
                            column(4, 
                                   h3("Understanding Sector-Wide Impact"),
                                   p("To help put into perspective the widespread,
                                     national economic crisis that COVID-19 has caused 
                                     for arts organizations, take a look at unemployment rates.
                                     While unemployment rates for artists specifically were lower than
                                     the general unemployement rate (shown as 'total' on the graph) 
                                     at the beginning of 2020, they skyrocketed
                                     during the pandemic and have yet to come 
                                     anywhere close to pre-pandemic
                                     levels. This suggests the need for special 
                                     relief legislation target specifically
                                     at helping artists and arts organizations.")),
                            
                            # I saved the animation as an html, so used 
                            # htmlOutput to get it
                            
                            column(8, 
                                   htmlOutput("animation"))
                          )),
                 
                 
                 # This panel explores textual responses in the survey via
                 # a word cloud and a table of written responses
                 
                 tabPanel("Textual Responses",
                          
                          # The word cloud is the first thing you see!
                          
                          wordcloud2Output("cloud"),
                          br(),
                          br(),
                          
                          # This row gives some background on textual responses
                          
                          fluidRow(
                            column(5, 
                                   h3("Beyond Numbers: Stories of the Pandemic's Impact"),
                                   p("At the end of the survey, participants were asked an optional
                                       open response question: Is there anything else you would like to 
                                       share about the impact of COVID-19 on your organization? People
                                       responded to this prompt in a variety of ways. Some expressed 
                                       fear about the unknown nature of the pandemic and its impact on 
                                       the arts sector, or detailed losses in the forms of cancelled 
                                       performances, slashed income, and social isolation. Others 
                                       detailed the innovative ways their organization had adapted to
                                       provide services for their community and expressed hope that 
                                       the arts could serve as a unifying and comforting force for 
                                       a fractured society. In later months, many respondents expressed
                                       a sense of exhaustion at the difficult and often demoralizing work
                                       of being an artist or arts administrator in this time. Many responses
                                       touched on multiple of these themes."),
                                   br(),
                                   p("Working with large datasets can sometimes feel very distant from
                                         the individual lives and stories that make up your data. I hope that
                                         by exploring some of the most commonly used words in participants'
                                         responses to these questions and reading through a few of the actual
                                         responses(organized by theme), you can begin to get a sense of the 
                                         profound impact of COVID-19 on the individuals who help produce art
                                         in this country")),
                            column(6, 
                            offset = 1, 
                            h4("Choose a sentiment using the drop down menu below to explore individual
                                           responses to the impact survey"),
                            
                            # This drop down menu allows the user to choose their sentiment of response
                            
                                   selectInput("sentiment", "Sentiment of Response", c("Fear", "Loss", "Resilience",
                                                                                       "Exhaustion")),
                                   tableOutput("response_table")))),
                 
                 # Finally, here's my About panel! Not much to say except it uses a 
                 # lot of links
                 
                 tabPanel("About",
                          
                          h2("About this Project"),
                          br(),
                          h4("About the Data"),
                          p("The bulk of the data for this project came from the Americans for the Arts (AFTA) 
                            survey on 'The Economic Impact of Coronavirus on the Arts and Culture Sector'. 
                            While AFTA has not made the raw survey responses available to the public due to 
                            confidentiality reasons, you can learn more about the survey and specific results 
                            on the", 
                            a("interactive dashboard on their website.", 
                              href = "https://www.americansforthearts.org/by-topic/disaster-preparedness/the-economic-impact-of-coronavirus-on-the-arts-and-culture-sector")),
                          p("The data on coronavirus cases came from", 
                            a("The Covid Tracking Project.", 
                              href = "https://covidtracking.com/data/download"),
                            "The data unemployment data across sectors was reported from the U.S. Bureau of Labor Statistics and can be accessed", a("on their website.", href = "https://data.bls.gov/timeseries/LNU04032241?amp%253bdata_tool=XGtable&output_view=data&include_graphs=true")),
                          p("For the code used to create this project, check out my", 
                            a("Github Repository.", 
                              href = "https://github.com/renacohen/final_project")),
                          br(),
                          h4("About the Cause"),
                          p("If nothing else, I hope you took away from this project that artists and arts organizations have
                             been devastated by the economic effects of the COVID-19 pandemic. I suggested in my project that
                             a national policy solution would be necessary; while this could take a variety of forms,
                             some possible solutions could be maintaining the unemployment benefits offered by the CARES
                             Act into the new year, creating a WPA-style federally funded effort to put artists back to work,
                             or introducing another round of federal relief to be distributed through the National Endowment
                             for the Arts."),
                          br(),
                            p("If you are interested in helping this
                             cause, consider reaching out to your local arts organizations, donating to an artist relief fund,
                             or contacting your representatitive to advocate for the arts using one of the many", 
                            a("advocacy tools offered by AFTA.", href = "https://www.americansforthearts.org/advocate")),
                          br(),
                          h4("Acknowlegements"),
                          p("First and foremost, I would like to thank my", 
                          strong("INCREDIBLE"), "TF Wyatt Hurt, whose patience, kindness, and penchant
                            for R-related memes gave me the motivation I needed to complete this project. I would also like to thank
                            head GOV-50 TF Tyler Simko for his incredible teaching skills and dedication to providing us all with 
                            such an excellent theoretical and coding background. Finally, I am very thankful to Randy Cohen, director
                            of Research at AFTA, as well as the rest of my AFTA colleagues for letting me explore their incredible data
                            for the purposes of this project."), 
                          h2("About Me"),
                          br(),
                          h4("Who am I?"),
                          p("An existential question I grapple with every day! But by way of a traditional
                          introduction, my name is Rena Cohen and I am a junior at Harvard studying
                          Women, Gender, and Sexuality with a secondary in Statistics. This project was 
                          completed as my final project for GOV 50, an introductory data science course.
                          In my free time, I love singing classical music, baking, thrifting, and hiking/running."),
                          br(),
                          h4("What is my relationship to Amerians for the Arts?"),
                          p("This summer, I was fortunate enough to serve as the Government Affairs and Education
                            intern at Americans for the Arts as part of the IOP's Director's Internship Program.
                            In this role, I helped to research and make advocacy materials to promote policies
                            that would include the arts and arts education in coronavirus relief efforts. As
                            an aspiring arts administrator, I was extremely grateful for the opportunity
                            to work with my colleagues at AFTA, and I hope that this project can serve
                            as a continuation to the incredible work that they do in ensuring all Americans
                            have access to create and experience artwork during this time.")))
