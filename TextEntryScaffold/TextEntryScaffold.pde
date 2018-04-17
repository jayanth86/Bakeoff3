import java.util.Arrays;
import java.util.Collections;
import java.lang.Math;
import java.util.Map;
import java.io.*;
import java.util.Scanner;
import java.util.Stack;


String[] phrases; //contains all of the phrases
int totalTrialNum = 4; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
final int DPIofYourDeviceScreen = 441; //you will need to look up the DPI or PPI of your device to make sure you get the right scale!!
//http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density
final float sizeOfInputArea = DPIofYourDeviceScreen*1; //aka, 1.0 inches square!
float divSize = sizeOfInputArea/29; // width / #of chars + 2 margins

//Variables for my silly implementation. You can delete this:
int dragPos = 0;
int widthtext = 50;
boolean mouseHold = false;
char currentLetter = 'a';

char[] letters = {'q', 'q', 'a', 'z', 'w', 's', 'x', 'e', 'd', 'c', 'r', 'f', 'v', 't', 'g', 'b', 'y', 'h', 'n', 'u', 'j', 'm', 'i', 'k', '\'', 'o', 'l', 'p', 'p'};
String[] letterStr = {"Q", "A", "Z", "W", "S", "X", "E", "D", "C", "R", "F", "V", "T", "G", "B", "Y", "H", "N", "U", "J", "M", "I", "K", "'", "O", "L", " ", "P"};
Map <String, Float> dict = new HashMap<String, Float>();
String currentWord = "";
Stack<String> words = new Stack<String>();
String [] possible = new String [4];



void boxwithtext(float x, float y,float width, float height, String txt, int bgr, int bgg, int bgb)  {
  fill(bgr,bgg,bgb);
  rect(x,y,width,height);
  fill(0);  
  if (txt != null){text(txt,x+.5*width,y+.6*height);}
}

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases

  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  size(900, 900); //Sets the size of the app. You may wantcreate to modify this to your device. May phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 24)); //set the font to arial 24
  noStroke(); //my code doesn't use any strokes
  BufferedReader reader =  createReader("hi.txt");  
  String line;
  try{
  while ((line = reader.readLine())!= null) 
  {
    String[] wordprob = line.split("\\s+");
    dict.put(wordprob[0], Float.valueOf(wordprob[1]));
  }
  reader.close();
  }
  catch(IOException ie)
  {
    println("hi");
  }
}

//You can modify anything in here. This is just a basic implementation.
void draw() 
{
  background(0); //clear background

  // image(watch,-200,200);
  fill(69, 68, 69);
  rect(200, 200, sizeOfInputArea, sizeOfInputArea); //input area should be 2" by 2"

  if (finishTime!=0)
  {
    fill(255);
    textAlign(CENTER);
    text("Finished", 280, 150);
    return;
  }

  if (startTime==0 & !mousePressed)
  {
    fill(255);
    textAlign(CENTER);
    text("Click to start time!", 280, 150); //display this messsage until the user clicks!
  }

  if (startTime==0 & mousePressed)
  {
    nextTrial(); //start the trials!
  }

  if (startTime!=0)
  {
    //you will need something like the next 10 lines in your code. Output does not have to be within the 2 inch area!
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 100, 100); //draw the trial count
    fill(255);
    text("Target:   ", 100, 140); //draw the target string
    text(currentPhrase, 200, 140);
    text("Entered:  ", 100, 180); //draw what the user has entered thus far 
    text(currentTyped +"|", 200, 180);
    fill(255, 0, 0);
    rect(200, 300+sizeOfInputArea, sizeOfInputArea, 200); //draw next button
    fill(255);
    textSize(50);
    textAlign(CENTER);
    text("NEXT > ", 200+(sizeOfInputArea/2), 420+sizeOfInputArea); //draw next label
    textSize(24);
    textAlign(LEFT);

    //draw code

    textAlign(CENTER);

    fill(69, 68, 69);
    stroke(245, 242, 220);
    //draw space
    rect(200, 200 + sizeOfInputArea * .75, sizeOfInputArea * .75, sizeOfInputArea * .25);

    //draw backspace
    rect(200 + sizeOfInputArea * .75, 200 + sizeOfInputArea * .75, sizeOfInputArea * .25, sizeOfInputArea * .25);

    fill(245, 242, 220);
    textSize(30);

    //space label
    text("space", 200 + sizeOfInputArea * .375, 200 + sizeOfInputArea * .9);

    //backspace label
    text("<", 200 + sizeOfInputArea * .875, 200 + sizeOfInputArea *.9);
    textSize(22);

    //draw letters
    for (int i = 0; i < 28; i++)
    {
      noStroke();
      fill(25*((i%3)+1), 25*((i%3)+1), 25*((i%3)+1));
      rect(200 + divSize*.5 + (i)*divSize, 201, divSize, 195 + sizeOfInputArea * .3);
      fill(245, 242, 220);
      text(letterStr[i], 200 + divSize + (i)*divSize, 200 + sizeOfInputArea *.1 + (sizeOfInputArea * .15) * (.5 * (i % 3)));
    }
    textSize(24);

    text(currentLetter, 20, 20);

    noFill();
    stroke(255, 87, 41);
    strokeWeight(2);

    //draw circles
    if (mouseHold == true && (hitTest(200, 200, sizeOfInputArea, sizeOfInputArea * .75)))
    {
      if (dragPos == 0)
      {
        ellipse(200 + 1 * divSize, 192 + sizeOfInputArea *.1 + (sizeOfInputArea * .15) * (.5 * ((0) % 3)), divSize*2, divSize*2);
      } else if (dragPos == 27 || dragPos == 29)
      {
        ellipse(200 + 28 * divSize, 192 + sizeOfInputArea *.1 + (sizeOfInputArea * .15) * (.5 * ((27) % 3)), divSize*2, divSize*2);
      } else
      {
        ellipse(200 + dragPos * divSize, 192 + sizeOfInputArea *.1 + (sizeOfInputArea * .15) * (.5 * ((dragPos-1) % 3)), divSize*2, divSize*2);
      }  
      line(mouseX, 200+sizeOfInputArea*.75, mouseX, 200);
    }
    
    stroke(245, 242, 220);
    boxwithtext(200,                         200 + sizeOfInputArea * 0.5, sizeOfInputArea * 0.5, widthtext, possible[0],100,100,150);
    boxwithtext(200 + sizeOfInputArea * 0.5, 200 + sizeOfInputArea * 0.5, sizeOfInputArea * 0.5, widthtext, possible[1],100,100,150);
    boxwithtext(200,                         200 + sizeOfInputArea * 0.5 + widthtext, sizeOfInputArea * 0.5, widthtext, possible[2],100,100,150);
    boxwithtext(200 + sizeOfInputArea * 0.5, 200 + sizeOfInputArea * 0.5 + widthtext, sizeOfInputArea * 0.5, widthtext, possible[3],100,100,150);
  }
}

boolean hitTest(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<(x)+(w) && mouseY>y && mouseY<(y)+(h)); //check to see if it is in button bounds
}


void mousePressed()
{
  mouseHold = true;
  String[] split = currentTyped.split("\\s+");
  if (hitTest(200, 200 + sizeOfInputArea/2, sizeOfInputArea, widthtext *2)){
    if (hitTest(200, 200 + sizeOfInputArea * 0.5, sizeOfInputArea * 0.5, widthtext)){
      currentWord = possible[0];
    }
    else if (hitTest(200 + sizeOfInputArea * 0.5, 200 + sizeOfInputArea * 0.5, sizeOfInputArea * 0.5, widthtext)){
      currentWord = possible[1];
    }
    else if (hitTest(200, 200 + sizeOfInputArea * 0.5 + widthtext, sizeOfInputArea * 0.5, widthtext)){
      currentWord = possible[2];
    }
    else if (hitTest(200 + sizeOfInputArea * 0.5, 200 + sizeOfInputArea * 0.5 + widthtext, sizeOfInputArea * 0.5, widthtext)){
      currentWord = possible[3];
    }
    int ctlength = split.length;
    String x = "";
    for (int i = 0; i < ctlength - 1; i++) 
    {
      x = x + split[i] + " ";
    }
    currentTyped = x + currentWord;
  }
  // Other Stuff 
  else if (hitTest(200, 200, sizeOfInputArea, sizeOfInputArea * .75))
  {
    dragPos = (int)Math.floor(((mouseX - 200)+divSize*.5) / divSize);
    if (dragPos < 29)
    {
      currentLetter = letters[dragPos];
    }
  }
    
}


void mouseDragged()
{
  if (hitTest(200, 200 + sizeOfInputArea/2, sizeOfInputArea, widthtext *2)){
  }
  //if mouse is in the drag input region, current letter is based on mouseX
  else if (hitTest(200, 200, sizeOfInputArea, sizeOfInputArea * .75))
  {
    dragPos = (int)Math.floor(((mouseX - 200)+divSize*.5) / divSize);
    if (dragPos < 29)
    {
      currentLetter = letters[dragPos];
    }
  }
  
}

void printarray(String[] possible)
{
  for (int i =0;i < 4; i++) 
  {
    println(possible[i]);
  }
}


String[] findmax(String currentWord)
{
  //println(currentWord);
  Stack<String> stack = new Stack<String>();
  float maxprob = 0f / 0f;
  boolean start = true;
  for (Map.Entry<String, Float> entry : dict.entrySet()) {
    String word = entry.getKey();
    Float prob = entry.getValue();
    if (start && word.startsWith(currentWord)) 
    {
      stack.push(word);
      start = !start;
      maxprob = prob;
    }
    else if (word.startsWith(currentWord) && (maxprob <= prob)){
        stack.push(word);
        prob = maxprob;
    }
  }
  int count = 0;
  for (int i = 0; i < 4; i++) 
  {
    possible[i] = "";
  }
  while (!stack.empty() && count < 4)
  {
    possible[count] = stack.pop();
    count++;
  }
  return possible;
}

void mouseReleased()
{
  mouseHold = false;
  //space
  if (hitTest(200, 200 + sizeOfInputArea * .75, sizeOfInputArea * .75, sizeOfInputArea * .25))
  {
    currentTyped += " ";
    currentWord = "";
  }

  //backspace
  if (hitTest(200 + sizeOfInputArea * .75, 200 + sizeOfInputArea * .75, sizeOfInputArea * .25, sizeOfInputArea * .25))
  {
    if (currentTyped.length() > 0)
    {
      currentTyped = currentTyped.substring(0, currentTyped.length()-1);
      if (currentWord.length() != 0) {currentWord = currentWord.substring(0,currentWord.length()-1);}
    }
    String[] split = currentTyped.split("\\s+");
    //println(currentWord.length(),  currentTyped.length() , currentTyped.charAt(currentTyped.length() - 1));
    if (currentWord.length() == 0 && currentTyped.length() > 0 && currentTyped.charAt(currentTyped.length() - 1) != ' ')
    {
      if (split.length == 0){currentWord = "";}
      else {
        currentWord = split[split.length - 1];
      }
    }
  }
  println(currentWord);
  
  if (hitTest(200, 200 + sizeOfInputArea/2, sizeOfInputArea, widthtext *2)){
  }
  //if in bounds, type current letter
  else if (hitTest(200, 200, sizeOfInputArea, sizeOfInputArea * .75))
  {
    currentTyped+=currentLetter;
    currentWord += currentLetter;
  }
   
  findmax(currentWord);
  //check if click is in next button
  if (hitTest(200, 300+sizeOfInputArea, sizeOfInputArea, 200)) 
  {
    nextTrial(); //if so, advance to next trial
  }
}


void nextTrial()
{
  currentWord = "";
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

  if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    System.out.println("Target phrase: " + currentPhrase); //output
    System.out.println("Phrase length: " + currentPhrase.length()); //output
    System.out.println("User typed: " + currentTyped); //output
    System.out.println("User typed length: " + currentTyped.length()); //output
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
    System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
    System.out.println("==================");
    lettersExpectedTotal+=currentPhrase.length();
    lettersEnteredTotal+=currentTyped.length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  //probably shouldn't need to modify any of this output / penalty code.
  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime)); //output
    System.out.println("Total letters entered: " + lettersEnteredTotal); //output
    System.out.println("Total letters expected: " + lettersExpectedTotal); //output
    System.out.println("Total errors entered: " + errorsTotal); //output

    float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
    System.out.println("Raw WPM: " + wpm); //output

    float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars

    System.out.println("Freebie errors: " + freebieErrors); //output
    float penalty = max(errorsTotal-freebieErrors, 0) * .5f;

    System.out.println("Penalty: " + penalty);
    System.out.println("WPM w/ penalty: " + (wpm-penalty)); //yes, minus, becuase higher WPM is better
    System.out.println("==================");

    currTrialNum++; //increment by one so this mesage only appears once when all trials are done
    return;
  }

  if (startTime==0) //first trial starting now
  {
    System.out.println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
  } else
  {
    currTrialNum++; //increment trial number
  }

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc"; // uncomment this to override the test phrase (useful for debugging)
}



//=========SHOULD NOT NEED TO TOUCH THIS METHOD AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2) //this computers error between two strings
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}