import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

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
int numbox = 0;
//Variables for my silly implementation. You can delete this:
char currentLetter = 'a';
boolean keyboardreset = false;

int [] keyboard = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
boolean erased = false;
long secondclick;
int bindex = -1;
boolean drag = false;

class Box 
{
  float x;
  float y;
  float width;
  float height;
  String txt;
  int bgr;
  int bgg;
  int bgb;
  int index;
  char currentletter = 'a';
  Box(float x1, float y1, float width1, float height1, String txt1, int bgr1, int bgg1, int bgb1, int index1)
  {
    x = x1;
    y = y1;
    width = width1;
    height = height1;
    txt = txt1;
    bgr = bgr1;
    bgg = bgg1;
    bgb = bgb1;
    index = index1; 
  }
  
}

Box abcd = new Box(200, 200, sizeOfInputArea/3, sizeOfInputArea/4, "abcd", 256, 256, 256,0);
Box efgh = new Box(200+sizeOfInputArea/3, 200, sizeOfInputArea/3, sizeOfInputArea/4, "efgh", 256, 256, 256,1);
Box ijkl = new Box(200+2*sizeOfInputArea/3, 200, sizeOfInputArea/3, sizeOfInputArea/4, "ijkl", 256, 256, 256,2);
Box mno = new Box(200, 200+sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4, "mno", 256, 256, 256,3);
Box pqr = new Box(200+sizeOfInputArea/3, 200+sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4, "pqr", 256, 256, 256,4);
Box stu = new Box(200+2*sizeOfInputArea/3, 200+sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4, "stu", 256, 256, 256, 5);
Box vw = new Box(200, 200+2*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4, "vw", 256, 256, 256, 6);
Box xy = new Box(200+sizeOfInputArea/3, 200+2*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4, "xy", 256, 256, 256, 7);
Box space = new Box(200, 200+3*sizeOfInputArea/4, 2*sizeOfInputArea/3, sizeOfInputArea/4, "space", 256, 256, 256, 8);
Box del = new Box(200+2*sizeOfInputArea/3, 200+3*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4, "del", 256, 0, 0, 9);
Box zapo = new Box(200+2*sizeOfInputArea/3, 200+2*sizeOfInputArea/4, sizeOfInputArea/3, sizeOfInputArea/4, "z'", 256, 256, 256, 10);
Box[] boxlist = new Box [] {abcd,efgh,ijkl,mno,pqr,stu,vw,xy,space,del,zapo};
Box[] dragboxlist = new Box[4];

void boxwithtext(float x, float y, float width, float height, String txt, int bgr, int bgg, int bgb) {
  fill(bgr, bgg, bgb);
  rect(x, y, width, height);
  fill(0);
  text(txt, x+.5*width, y+.6*height);
  return;
}

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases)); //randomize the order of the phrases

  orientation(PORTRAIT); //can also be LANDSCAPE -- sets orientation on android device
  size(1000, 1000); //Sets the size of the app. You may want to modify this to your device. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 24)); //set the font to arial 24
  noStroke(); //my code doesn't use any strokes.
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(0); //clear background

  // image(watch,-200,200);
  fill(100);
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
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
    fill(255);
    text("Target:   " + currentPhrase, 70, 100); //draw the target string
    text("Entered:  " + currentTyped +"|", 70, 140); //draw what the user has entered thus far 
    fill(255, 0, 0);
    rect(800, 00, 200, 200); //draw next button
    fill(255);
    text("NEXT > ", 850, 100); //draw next label

    //my draw code
    textAlign(CENTER);
    stroke(204, 102, 0);
   
    for (int i = 0; i < boxlist.length; i++)
    {
      Box b = boxlist[i];
      boxwithtext(b.x,b.y,b.width,b.height,b.txt,b.bgr,b.bgg,b.bgb);
      if (drag)
      {
        dragbox(bindex);
      }
    }
    
  }
}




boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}


void refresharray(int t)
{
  for (int i = 0; i < (keyboard).length; i++)
  {
    if (i != t )
    {
      keyboard[i] = 0;
    }
  }
}

boolean isok()
{
  for (int i = 0; i < keyboard.length; i++)
  {
    if (keyboard[i] != 0)
    {
      return false;
    }
  }
  return true;
}



void dragbox(int index)
{
  float x0 = 0;
  float y0 = 0;
  String txt = "";
  
  Box b = boxlist[index];
  txt = boxlist[index].txt;
  if((index < 8) || (index == 10))
  {
    x0 = boxlist[index%3].x;
    y0 = boxlist[index].y;
    if(index < 3)  {
      numbox = 4;
    }  else if(index < 6)  {
      numbox = 3;
    } else  {
      numbox = 2;
    }
  }
  // Drawing the dragging boxes
  for (int i = 0; i < numbox; i++)
  {
    Box temp;
    if (bindex == 10) {temp = new Box (x0 + b.width, y0 +b.height * i,b.width,b.height,txt.charAt(i) + "", 200, 200,255,0);}
    else{temp = new Box (x0, y0 +b.height * i,b.width,b.height,txt.charAt(i) + "", 200, 200,255,0);}
    dragboxlist[i] = temp;
    if (bindex == 10) {boxwithtext(x0 + b.width,y0+b.height * i,b.width,b.height,txt.charAt(i) + "", 200, 200,255);}
    else {boxwithtext(x0,y0+b.height * i,b.width,b.height,txt.charAt(i) + "", 200, 200,255);}
  }
}


long firstclick = 0;

void mousePressed()
{
  if (startTime !=0 )
  {

    for (int i = 0; i < boxlist.length; i++)
    {
      Box b = boxlist[i];
      if (didMouseClick(b.x, b.y, b.width, b.height))
      {
        bindex = b.index ;
      }
    }
    
    if (0<= bindex && bindex <= 7 || (bindex == 10) )
    {
      drag = true;
    } 
    // space 
    else if (bindex == 8)
    {
       refresharray(-1);
       currentLetter = ' ';
       currentTyped += currentLetter;
    }
    // del
    else if (bindex == 9 && currentTyped.length()>0)
    {
      refresharray(-1);
      currentTyped = currentTyped.substring(0, currentTyped.length()-1);
    }

    //You are allowed to have a next button outside the 2" area
    if (didMouseClick(800, 00, 200, 200)) //check if click is in next button
    {
      nextTrial(); //if so, advance to next trial
    }
    firstclick = secondclick;
    
  }
}


void nextTrial()
{
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
  refresharray(-1);
  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!

}

void mouseReleased()
{
  int clickedboxindex = -1;
  if (drag)
  {
    for (int j = 0; j <numbox ; j++)
    {
      Box clickbox = dragboxlist[j];
      if (didMouseClick(clickbox.x, clickbox.y, clickbox.width, clickbox.height))
      {
        clickedboxindex = j;
      }
    }
    // Typing
    if (clickedboxindex >= 0)
    {
      currentTyped+=dragboxlist[clickedboxindex].txt;
    }
    drag = !drag; 
  }
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