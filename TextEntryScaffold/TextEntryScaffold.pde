import java.util.Arrays;
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

//Variables for my silly implementation. You can delete this:
char currentLetter = 'a';
boolean keyboardreset = false;

int [] keyboard = {0,0,0,0,0,0,0,0,0,0,0,0};
boolean erased = false;
long secondclick;


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
    rect(200, 200+1.5*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6);
    fill(0);
    text("abc", 200+sizeOfInputArea/6, 200+1.5*sizeOfInputArea/3 + sizeOfInputArea/9); //draw current letter
    fill(255);
    rect(200, 200+2*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6);
    fill(0);
    text("jkl", 200+sizeOfInputArea/6, 200+2*sizeOfInputArea/3 + sizeOfInputArea/9); //draw current letter
    fill(255);
    rect(200, 200+2.5*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6);
    fill(0);
    text("tuv", 200+sizeOfInputArea/6, 200+2.5*sizeOfInputArea/3 + sizeOfInputArea/9); //draw current letter
    fill(255);
    
    rect(200+sizeOfInputArea/3, 200+1.5*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6);
    fill(0);
    text("def", 200+3*sizeOfInputArea/6, 200+1.5*sizeOfInputArea/3 + sizeOfInputArea/9); //draw current letter
    fill(255);
    rect(200+sizeOfInputArea/3, 200+2*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6);
    fill(0);
    text("mno", 200+3*sizeOfInputArea/6, 200+2*sizeOfInputArea/3 + sizeOfInputArea/9); //draw current letter
    fill(255);
    rect(200+sizeOfInputArea/3, 200+2.5*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6);
    fill(0);
    text("wxyz", 200+3*sizeOfInputArea/6, 200+2.5*sizeOfInputArea/3 + sizeOfInputArea/9); //draw current letter
    fill(255);
    
    rect(200+2*sizeOfInputArea/3, 200+1.5*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6);
    fill(0);
    text("ghi", 200+5*sizeOfInputArea/6, 200+1.5*sizeOfInputArea/3 + sizeOfInputArea/9); //draw current letter
    fill(255);
    rect(200+2*sizeOfInputArea/3, 200+2*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6);
    fill(0);
    text("pqrs", 200+5*sizeOfInputArea/6, 200+2*sizeOfInputArea/3 + sizeOfInputArea/9); //draw current letter
    fill(255);
    rect(200+2*sizeOfInputArea/3, 200+2.5*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6);
    fill(0);
    text("'", 200+5*sizeOfInputArea/6, 200+2.5*sizeOfInputArea/3 + sizeOfInputArea/9); //draw current letter
    fill(255);
    rect(200, 200+sizeOfInputArea/3, sizeOfInputArea/2, sizeOfInputArea/6);
    fill(0);
    text("Space", 200 + sizeOfInputArea/4, 200+sizeOfInputArea/3 + sizeOfInputArea/9);
    fill(255, 0, 0);
    rect(200+sizeOfInputArea/2, 200+sizeOfInputArea/3, sizeOfInputArea/2, sizeOfInputArea/6);
    fill(0);
    text("Back", 200 + 3*sizeOfInputArea/4, 200+sizeOfInputArea/3 + sizeOfInputArea/9);
    fill(255);
    text("" + currentLetter, 200+sizeOfInputArea/2, 200+sizeOfInputArea/3 - 50); //draw current letter
  }
}

boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}


void refresharray(int t)
{
  for (int i = 0; i < (keyboard).length;i++)
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


long firstclick = 0;
boolean first = true;
void mousePressed()
{
  if (startTime !=0)
  {
    if (first) 
    {
      firstclick = System.currentTimeMillis() % 100000;
      first = false;
    }
  
    long secondclick = System.currentTimeMillis() % 100000;
    println("firstclick", firstclick, "secondclick", secondclick);
    if (abs(secondclick - firstclick) > 500) 
    {
      refresharray(-1);
    }
    firstclick = secondclick;
    // jkl 
    if (didMouseClick(200, 200+2*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6))
    {
      refresharray(3);
      if (keyboard[3] == 0) {
        currentLetter = 'j';
      }
      else if (keyboard[3]% 3 == 0)
      {
        currentTyped = currentTyped.substring(0, currentTyped.length()-1);
        currentLetter = 'j';
      }
      else if (keyboard[3]%3 == 1){
        currentTyped = currentTyped.substring(0, currentTyped.length()-1);
        currentLetter = 'k';
      }
      else if (keyboard[3]%3 == 2){
        currentTyped = currentTyped.substring(0, currentTyped.length()-1);
        currentLetter = 'l';
      }
      keyboard[3]++;
      currentTyped+=currentLetter;
    }
    // abc 
    if (didMouseClick(200, 200+1.5*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6))
    {
      println("======================================");
      refresharray(0);
      if (keyboard[0] == 0){currentLetter='a';}
      else 
      {
        currentTyped = currentTyped.substring(0, currentTyped.length()-1);
        if (keyboard[0]%3 == 0) {currentLetter = 'a';}
        else if (keyboard[0]%3 == 1){currentLetter = 'b';}
        else if (keyboard[0]%3 == 2){currentLetter = 'c';}
      }
       keyboard[0]++;
       currentTyped+=currentLetter;
    }
    
    // tuv
    else if (didMouseClick(200, 200+2.5*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6))
    {
      refresharray(6);
      if (keyboard[6] == 0){currentLetter='t';}
      else // if (keyboard[6] % 3 ==0 || keyboard[6] % 3 ==1 || keyboard[6] % 3 == 2)
      {
        currentTyped = currentTyped.substring(0, currentTyped.length()-1);
        if (keyboard[6]%3 == 0) {currentLetter = 't';}
        else if (keyboard[6]%3 == 1){currentLetter = 'u';}
        else if (keyboard[6]%3 == 2){currentLetter = 'v';}
      }
       keyboard[6]++;
       currentTyped+=currentLetter;
    }
    // def 
    else if (didMouseClick(200+sizeOfInputArea/3, 200+1.5*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6))
    {
      refresharray(1);
      if (keyboard[1] == 0){currentLetter='d';}
      else 
      {
        currentTyped = currentTyped.substring(0, currentTyped.length()-1);
        if (keyboard[1]%3 == 0) {currentLetter = 'd';}
        else if (keyboard[1]%3 == 1){currentLetter = 'e';}
        else if (keyboard[1]%3 == 2){currentLetter = 'f';}
      }
       keyboard[1]++;
       currentTyped+=currentLetter;
    }
    // mno 
    else if (didMouseClick(200+sizeOfInputArea/3, 200+2*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6))
    {
      refresharray(4);
      if (keyboard[4] == 0){currentLetter='m';}
      else 
      {
        currentTyped = currentTyped.substring(0, currentTyped.length()-1);
        if (keyboard[4]%3 == 0) {currentLetter = 'm';}
        else if (keyboard[4]%3 == 1){currentLetter = 'n';}
        else if (keyboard[4]%3 == 2){currentLetter = 'o';}
      }
       keyboard[4]++;
       currentTyped+=currentLetter;
    }
    // wxyz
    else if (didMouseClick(200+sizeOfInputArea/3, 200+2.5*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6))
    {
      refresharray(7);
      if (keyboard[7] == 0) {currentLetter = 'w';}
      else
      {
        
        currentTyped = currentTyped.substring(0, currentTyped.length()-1);
        if (keyboard[7] % 4 == 0){currentLetter = 'w';}
        else if (keyboard[7] % 4 == 1){currentLetter = 'x';}
        else if (keyboard[7] % 4 == 2){currentLetter = 'y';}
        else if (keyboard[7] % 4 == 3){currentLetter = 'z';}
      }
      keyboard[7]++;
      currentTyped+=currentLetter;
    }
    // ghi
    else if (didMouseClick(200+2*sizeOfInputArea/3, 200+1.5*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6))
    {
      refresharray(2);
      if (keyboard[2] == 0) {currentLetter = 'g';}
      else
      {
        currentTyped = currentTyped.substring(0, currentTyped.length()-1);
        if (keyboard[2] % 3 == 0){currentLetter = 'g';}
        else if (keyboard[2] % 3 == 1){currentLetter = 'h';}
        else if (keyboard[2] % 3 == 2){currentLetter = 'i';}
      }
      keyboard[2]++;
      currentTyped+=currentLetter;
    }
  // pqrs
    else if (didMouseClick(200+2*sizeOfInputArea/3, 200+2*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6))
    {
      refresharray(5);
      if (keyboard[5] == 0) {
        currentLetter = 'p';
      }
      else
      {
        currentTyped = currentTyped.substring(0, currentTyped.length()-1);
        if (keyboard[5] % 4 == 0){currentLetter = 'p';}
        else if (keyboard[5] % 4 == 1){currentLetter = 'q';}
        else if (keyboard[5] % 4 == 2){currentLetter = 'r';}
        else if (keyboard[5] % 4 == 3){currentLetter = 's';}
      }
      keyboard[5]++;
      currentTyped+=currentLetter;
    }
    
    else if (didMouseClick(200+2*sizeOfInputArea/3, 200+2.5*sizeOfInputArea/3, sizeOfInputArea/3, sizeOfInputArea/6))
    {
        refresharray(-1);
        currentLetter = '\'';
        currentTyped+=currentLetter;
    }
    
    else if (didMouseClick(200, 200+sizeOfInputArea/3, sizeOfInputArea/2, sizeOfInputArea/6))
    {
      refresharray(-1);
      currentLetter = ' ';
      currentTyped+=currentLetter;
    }
    
    // Back
    else if (didMouseClick(200+sizeOfInputArea/2, 200+sizeOfInputArea/3, sizeOfInputArea/2, sizeOfInputArea/6)
               && currentTyped.length()>0) //if `, treat that as a delete command
    {
        refresharray(-1);
        currentTyped = currentTyped.substring(0, currentTyped.length()-1);
    }

    //You are allowed to have a next button outside the 2" area
    else if (didMouseClick(800, 00, 200, 200)) //check if click is in next button
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