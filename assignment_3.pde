// Variables
int buttonY = 400;
int buttonWidth = 125, buttonHeight = 60;

// Score
int startTime = 0;
int timerDuration = 10;
int scoreTimerLeft = timerDuration;
int score = 0;

// ButtonX Size
int easyButtonX = 70;
int mediumButtonX = 240;
int hardButtonX = 405;

// Gameplay vars
String modeOfChoice = "";
boolean selectedMode = false;
boolean gameOver = false;

String correctAnswer;
char randomLetter;

void setup() {
  size(600, 600);
  background(50);

  startTime = millis();
}

void draw() {

  if (!gameOver) {
    fill(255);
    textSize(40);
    text("Typing test. Select a difficulty", 50, 100);
  
    // Creating buttons \\
  
    // Easy button
    fill(233, 255, 31);
    rect(easyButtonX, buttonY, buttonWidth, buttonHeight);
    textSize(40);
    fill(0);
    text("Easy", 90, 440);
  
    // Medium button
    fill(56, 220, 229);
    rect(mediumButtonX, buttonY, buttonWidth, buttonHeight);
    textSize(38);
    fill(0);
    text("Medium", 240, 440);
  
    // Hard button
    fill(255, 34, 31);
    rect(hardButtonX, buttonY, buttonWidth, buttonHeight);
    fill(0);
    text("Hard", 430, 440);
  }

  // Player has selected a mode
  if (selectedMode) {

    if (modeOfChoice == "Easy") {
      background(230, 236, 50);
    } else if (modeOfChoice == "Medium") {
      background(45, 195, 240);
    } else if (modeOfChoice == "Hard") {
      background(222, 63, 74);
    }
    fill(0);

    // Timer
    
    // Time over
    scoreTimerLeft =  timerDuration - (millis() - startTime) / 1000;
    
    if (scoreTimerLeft < 0) {
      scoreTimerLeft = 0;
      gameOver = true;
      fill(120);
      
      background(183, 72, 182);
      textSize(64);
      fill(0);
      
      // Game over text
      text("Game Over!", 125, 100);
      textSize(50);
      text("Score: " + score, 175, 400);
      
    } else {
      fill(240, 10, 10);
      textSize(32);
      text(scoreTimerLeft, 100, 500);
      
      // Key still needs to be pressed
      textSize(60);
      fill(0);
      text("Press this key.", 130, 100);

      textSize(90);
      fill(0);
      text(Character.toLowerCase(randomLetter), 275, 300);
    }

  }
  if (selectedMode && correctAnswer == "no") {
    background(240, 10, 20);
    textSize(72);
    text("Wrong Answer! :(", 50, 100);
  }
}

void mousePressed() {
  // Already chose a mode, so no need for mouse input
  if (modeOfChoice != "") {
    modeOfChoice = modeOfChoice;
    return;
  }

  // Pressed easy button
  if (mouseX >= easyButtonX &&
    mouseX <= easyButtonX + buttonWidth &&
    mouseY >= buttonY &&
    mouseY <= buttonY + buttonHeight)
  {
    modeOfChoice = "Easy";

    randomLetter = (char) random('a', 'g' + 1);
  } else if (mouseX >= mediumButtonX &&
    mouseX <= mediumButtonX + buttonWidth &&
    mouseY >= buttonY &&
    mouseY <= buttonY + buttonHeight)
  {
    modeOfChoice = "Medium";
    randomLetter = (char) random('g', 'n' + 1);
  } else if (mouseX >= hardButtonX &&
    mouseX <= hardButtonX + buttonWidth &&
    mouseY >= buttonY &&
    mouseY <= buttonY + buttonHeight)
  {
    modeOfChoice = "Hard";
    randomLetter = (char) random('n', 'z' + 1);
  } else {
    return;
  }
  selectedMode = true;
}

void keyPressed() {
  if (correctAnswer == "no") {
   return;
  }
  if (selectedMode && Character.toLowerCase(key) == Character.toLowerCase(randomLetter)) {
    correctAnswer = "yes";
    score++;

    // Generate the next random letter
    if (modeOfChoice == "Hard") {
      randomLetter = (char) random('n', 'z' + 1);
    } else if (modeOfChoice == "Medium") {
      randomLetter = (char) random('g', 'n' + 1);
    } else if (modeOfChoice == "Easy") {
      randomLetter = (char) random('a', 'g' + 1);
    }
  } else if (selectedMode && Character.toLowerCase(key) != Character.toLowerCase(randomLetter)) {
    correctAnswer = "no";
    gameOver = true;
    
    modeOfChoice = "";
  }
}
