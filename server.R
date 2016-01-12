library(shiny)
library(plyr)
load("kandothAnno.Rdata")
load("numBySample.Rdata")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
#for "CADD Summary" Tab  
#Returns the requested data for the CADD distribution histogram
  datasetInput <- reactive({
    switch(input$distributionData,
           "All"=na.omit(kandothAnno2$v13CADDscaled),
           "Missense"=na.omit(kandothAnno2[kandothAnno2$Variant_Classification=="Missense",]$v13CADDscaled), 
           "Nonsense"=na.omit(kandothAnno2[kandothAnno2$Variant_Classification=="Nonsense",]$v13CADDscaled), 
           "Nonstop"=na.omit(kandothAnno2[kandothAnno2$Variant_Classification=="Nonstop",]$v13CADDscaled), 
           "RNA"=na.omit(kandothAnno2[kandothAnno2$Variant_Classification=="RNA",]$v13CADDscaled), 
           "Silent"=na.omit(kandothAnno2[kandothAnno2$Variant_Classification=="Silent",]$v13CADDscaled), 
           "Splice Site"=na.omit(kandothAnno2[kandothAnno2$Variant_Classification=="Splice_Site",]$v13CADDscaled))
  })
#generate summary of the distribution
  output$summary<-renderPrint({
    distributionData<-datasetInput()
    summary(distributionData)
  })
#CADD distribution histogram
  output$scaledCADD <- renderPlot({
    distributionData    <- datasetInput()  # R object in loaded data
    bins <- seq(min(distributionData), max(distributionData), length.out = input$bins + 1)
# draw the histogram with the specified number of bins
    hist(distributionData, breaks=bins, col = 'blue', border = 'white', xlab="CADD", main="CADD Mutation Frequency")
  })
  
  #Variant Classification barplot
  mytable<-table(kandothAnno2$Variant_Classification)
  names(mytable)[2]<-"Frameshift_Del"
  names(mytable)[1]<-"NA"
  names(mytable)[3]<-"Frameshift_Ins"
  names(mytable)[4]<-"InframeDel"
  names(mytable)[5]<-"InframeIns"
  dfTable<-as.data.frame(mytable)
  dfTable<-dfTable[order(-dfTable$Freq),]
  library(ggplot2)
  output$bp<-renderPlot({ggplot(dfTable, aes(x="", y=Freq, fill=Var1))+
      geom_bar(width=1, colour="black", stat="identity") + scale_fill_manual(values=c("white", "orange", "lightblue", "black", "gray", "red", "blue", "pink", "purple", "green", "yellow"))+
      labs(x="Variant Classification", y="Variant Frequency")})
  
  #Samples by Cancer Pie Chart
  numByCancer<-table(numBySample$V3)
  numByCancerDF<-as.data.frame(numByCancer)
  #pie chart
  output$pieCancer<-renderPlot({ggplot(numByCancerDF, aes(x="", y=Freq, fill=Var1))+
      geom_bar(width=1, stat="identity")+
      theme(panel.background=element_blank())+
      coord_polar("y", start=0)+
      theme(axis.text.x=element_blank())+
      scale_fill_brewer(palette="Set3")+
      scale_x_discrete(name="")+
      scale_y_discrete(name="")})
  
  #numBySample is the number of mutations by each sample, annotated with tumor type
  small<-subset(numBySample, numBySample$Freq<3000)
  output$bp4<-renderPlot({ggplot(small, aes(V3, Freq))+
      geom_jitter()+
      theme(axis.text.x=element_text(angle=90, hjust=1))+
      labs(x="Cancer", y="# of Variants per Sample")})
  
  output$variantCount<-renderText({paste("Total Number of Variants:", nrow(kandothAnno2))})
  
  output$sampleCount<-renderText({paste("Total Number of Samples:", length(unique(kandothAnno2$ShortTumor_Sample)))})
  
  output$cancerCount<-renderText({paste("Number of Cancers Represented:", length(unique(kandothAnno2$Cancer))-1)}) #-1 accounts for "NA"
  
  output$cancerSummary<-renderDataTable({count(kandothAnno2, 'Cancer')})
  
  geneCount<-count(kandothAnno2, 'Gene.x')
  output$geneSummary<-renderDataTable({geneCount[order(-geneCount$freq),]}, options=list(lengthMenu=c(10, 20, 30, 40, 50), pageLength=10))
})