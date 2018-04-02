
// This function is required, this is called once, and used to setup your 
// visualization environment
int mode = 0;
int modeCount = 0;
float dataMin;
float dataMax;
int columnCount = 0;
int[] triples;
int tripleMin;
int tripleMax;
FloatTable data;
float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;
int volumeIntervalMinor = 5;
// Big tick line
int volumeInterval = 100;
int currentColumn;
int yearInterval = 10;
int cetusColumn = 0;
int cooleyColumn = 1;
int rowCount;
// Tab variables for the menus
float[] tabLeft, tabRight; // Add above setup() 
float tabTop, tabBottom;
float tabPad = 10;
int visualization = 0;
int vizCount = 4;
int yMarks;
void setup() {
    // This is your screen resolution, width, height
    //  upper left starts at 0, bottom right is max width,height
    size(1000,600);
  
    // This calls the class FloatTable - java class 
    data = new FloatTable("TCores.tsv");
    rowCount = data.getRowCount();
    print("row count " + rowCount + "\n");
    // Retrieve number of columns in the dataset
    columnCount = data.getColumnCount();
    dataMin = 0;
    dataMax = data.getTableMax();
    yMarks = (int) dataMax / rowCount;
    print("Y marks " + yMarks + "\n");
    triples = int(data.getRowNames());  
    tripleMin = 0; // triples[0];
    tripleMax = triples[triples.length - 1];
    print("Min " + tripleMin + " max " + tripleMax + " column count " + columnCount + "\n");
  
  
    // Corners of the plotted time series
    plotX1 = 120;
    plotX2 = width - 80;
    labelX = 50;
    plotY1 = 60;
    plotY2 = height - 80;
    labelY = height - 25;
  
 
  

  
  
    rowCount = data.getRowCount();
    for (int row = 0; row < rowCount; row++) {
        float initialValue = data.getFloat(row, 0);
        print("value " + initialValue + "\n");
    }  
  
  
  
  
}
//Require function that outputs the visualization specified in this function
// for every frame. 
void draw() {
  
  
    // Filling the screen white (FFFF) -- all ones, black (0000)
    background(255);
    drawVisualizationWindow();
    drawGraphLabels();
 
   // These functions contain the labels along with the tick marks
    drawYTickMarks();
    drawXTickMarks();
    drawDataPoints();
  
}


void drawVolumeData(int col) {
  beginShape( );
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      //float value = interpolators[row].value;
      float value = data.getFloat(row, col);
      float x = map(triples[row], tripleMin, tripleMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      vertex(x, y);
    }
  }
  // Draw the lower-right and lower-left corners.
  vertex(plotX2, plotY2);
  vertex(plotX1, plotY2);
  endShape(CLOSE);
  
}
void drawDataPoints() {
  fill(#0000FF);   // Color blue
  for ( int row = 0; row < rowCount; row++ ) {
      float value = data.getFloat(row,cooleyColumn);
    
    float y = mapLog(value);
    float x = map(row,0,rowCount-1,plotX1,plotX2);
    ellipse(x, y, 5, 5);
  }
  fill(#FF0000);   // Color red
  for ( int row = 0; row < rowCount; row++ ) {
    float value = data.getFloat(row,cooleyColumn);
    float x = map(triples[row], tripleMin, tripleMax, plotX1, plotX2);
    float y = map(value, dataMin, dataMax, plotY2, plotY1);
    ellipse(x, y, 5, 5);
  }
}
void drawDataLine(int col) {
  beginShape( );
  rowCount = data.getRowCount();
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, cooleyColumn)) {
      float value = data.getFloat(row, col);
      float x = map(triples[row], tripleMin, tripleMax, plotX1, plotX2); 
      float y = map(value, dataMin, dataMax, plotY2, plotY1); 
      vertex(x, y);
    }
    
    
  }
  endShape( );
}
float barWidth = 2; // Add to the end of setup()

void drawYTickMarks() {
  fill(0);
  textSize(10);
  stroke(128);
  strokeWeight(1);
  int tickStart = 8;

    for (int i = 0; i < rowCount; i++ ) {
   // if (v % volumeIntervalMinor == 0) { // If a tick mark
   
      float y = map(i, 0, rowCount-1, plotY2, plotY1);
        if (i == 0) {
          textAlign(RIGHT); // Align by the bottom
        } else if (i == rowCount -1) {
          textAlign(RIGHT, TOP); // Align by the top
        } else {
          textAlign(RIGHT, CENTER); // Center vertically
        }
        
        text((int) pow(2,tickStart), plotX1 - 10, y);
        tickStart += 1;
        line(plotX1 - 4, y, plotX1, y); // Draw major tick
  }  
  
}
float mapLog(float value) {
   int startPoint = 8;
   float newVal = 0;
   for (int i = 0; i < rowCount; i ++ ) {
      
      float lowValue =  pow(2,startPoint);
      float topValue =  pow(2,startPoint+1);
      startPoint += 1;
      
      if (value > lowValue && value < topValue) {
         
         newVal = map(log(value), log(lowValue), log(topValue), i,i+1);
        
      }  
   }
   
//  print(" NEW VAL IS " + newVal);
  float y = map(newVal, 0, rowCount-1, plotY2, plotY1);
  return y;
  
}
void drawXTickMarks() {
  
  fill(0);
  textSize(10);
  textAlign(CENTER, TOP);
  // Use thin, gray lines to draw the grid.
  stroke(224);
  strokeWeight(1);
  for (int row = 0; row < rowCount; row++) {
      float x = map(row, 0, rowCount-1, plotX1, plotX2);
      text(triples[row], x, plotY2 + 10);
      
      // Long verticle line over each year interval
      line(x, plotY1, x, plotY2);
  } 
  
}
void drawVisualizationWindow() {
    fill(255);
  rectMode(CORNERS);
  // noStroke( );
  rect(plotX1, plotY1, plotX2, plotY2);
  
}
void drawGraphLabels() {
  fill(0);
  textSize(15);
  textAlign(CENTER, CENTER);
  float x1 = labelX;
  float y1 = (plotY1+plotY2)/2;
  text("types of balls", (plotX1+plotX2)/2, labelY);  
 
   pushMatrix();
  translate(x1,y1);
  rotate(-HALF_PI);
  translate(-x1,-y1);
  
  text("time in air (sec) ", labelX, (plotY1+plotY2)/2);
  popMatrix();
}
