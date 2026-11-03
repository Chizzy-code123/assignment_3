/*
   Chizzy
 I'm making a block breaker type game that I saw on google
 
 The mechanics in this game will be
 - Moving paddle that can hit the moving ball
 - Rectangles that will increase the player's score if hit
 - Score
 - Retry button
 */

// References

// Variables
boolean roundStarted = false;
boolean ballInPlay = false;

boolean leftPressed = false;
boolean rightPressed = false;
boolean gameOver = false;

int score = 0;
int maxLives = 1;
int livesCount = maxLives;

// Buttons
int startButtonX = 125, startButtonY = 340, startButtonWidth = 350, startButtonHeight = 100;
int paddleX = 200, paddleY = 480, paddleWidth = 150, paddleHeight = 15;

// Bouncing ball
int ballX = paddleX + paddleWidth / 2, ballY = paddleY - 25, ballRadius = 25;

// Blocks
int startBlockX = 40, startBlockY = 60;
int blockX = startBlockX, blockY = startBlockY, blockWidth = 75, blockHeight = 25, blockRadius = 10;
boolean blocksLoaded = false;

// Configurations
int screenWidth = 600, screenHeight = 600;
int paddleSpeed = 10;
float ballSpeedX = 4, ballSpeedY = 4;

boolean blockCollisionDebounce = false;
float lastBlockCollision;
float collisionCooldown = 250;

int blockMaxCount = 28;
int blockColumns = 7;
int blockSpacingX = 75, blockSpacingY = 30;
int blockCount = blockMaxCount;
int blockPointsWorth = 50;

boolean[] blockAlive = new boolean[blockMaxCount];

PImage livesIcon;
int livesX = 20, livesY = 20;

void setup() {
  size(600, 600);
  background(20);
  livesIcon = loadImage("love-always-wins.png");

  for (int i = 0; i < blockMaxCount; i++) {
    blockAlive[i] = true;
  }
}

// Handles ball movement and collision
void updateBall() {
  if (gameOver) {
    return;
  }
  // Moving the ball
  ballX += ballSpeedX;
  ballY += ballSpeedY;

  // Ball hitting the left wall
  if (ballX - ballRadius < 0) {
    ballX = ballRadius;
    ballSpeedX *= -1;
  }

  // Ball hitting the right wall
  if (ballX + ballRadius > screenWidth) {
    ballX = screenWidth - ballRadius;
    ballSpeedX *= -1;
  }

  // Hitting the top
  if (ballY - ballRadius < 0) {
    ballY = ballRadius;
    ballSpeedY *= -1;
  }

  // Ball and paddle collision
  if (ballX >= paddleX && ballX <= paddleX + paddleWidth &&
    ballY + ballRadius >= paddleY && ballY <= paddleY + paddleHeight && ballSpeedY > 0) {

    float paddleCenterX = paddleX + (paddleWidth / 2.0);
    float hitOffset = ballX - paddleCenterX;
    float normalizedHit = hitOffset / (paddleWidth / 2.0);

    float maxHorizontalSpeed = 8.0;
    ballSpeedX = normalizedHit * maxHorizontalSpeed;

    float upwardSpeed = 5.5;
    ballSpeedY = -upwardSpeed;

    ballY = paddleY - ballRadius;
  }

  // Player lost a life
  if (ballY + ballRadius > screenHeight) {
    resetBall();

    livesCount -= 1;
    if (livesCount <= 0) {
      gameOver();
    }
  }
}

void gameOver() {
  println("Player has lost all their lives!");
  livesCount = maxLives;
  score = 0;
  resetBlocks();
  gameOver = true;
}

void resetBall() {
  paddleX = 200;
  paddleY = 480;

  ballX = paddleX + paddleWidth / 2;
  ballY = paddleY - 25;
}

void resetBlocks() {
  blockCount = blockMaxCount;
  for (int i = 0; i < blockMaxCount; i++) {
    blockAlive[i] = true;
  }
  resetBall();
}

void draw() {
  // Title
  textSize(64);
  fill(255);
  text("Block Breaker", 125, 100);

  rect(startButtonX, startButtonY, startButtonWidth, startButtonHeight, 15);
  textSize(55);
  fill(0);
  text("Start", 235, 410);

  // Paddle movement
  if (rightPressed && paddleX < screenWidth - paddleWidth) {
    paddleX += paddleSpeed;
  }

  if (leftPressed && paddleX > 0) {
    paddleX -= paddleSpeed;
  }

  // Block collision debounce
  if (blockCollisionDebounce) {
    if (millis() - lastBlockCollision >= collisionCooldown) {
      blockCollisionDebounce = false;
    }
  }

  // Starting the game
  if (roundStarted) {
    background(20);
    // Create the paddle
    fill(255);
    rect(paddleX, paddleY, paddleWidth, paddleHeight, 15);

    // Add lives
    for (int i = 1; i <= livesCount; i++) {
      image(livesIcon, livesX * i * 2, livesY);
    }

    updateBall();

    // Create the ball
    circle(ballX, ballY, ballRadius);

    // Load the blocks
    for (int i = 0; i <= blockMaxCount - 1; i++) {

      if (!blockAlive[i]) {
        continue;
      }

      int col = i % blockColumns;
      int row = i / blockColumns;

      // Positions
      int x = startBlockX + col * blockSpacingX;
      int y = startBlockY + row * blockSpacingY;

      fill(210, 198, 45);

      // Setting the colors of the block
      if (i > 0 && i < 7) {
        fill(210, 198, 45);
      } else if (i > 0 && i < 14) {
        fill(0, 133, 18);
      } else if (i > 0 && i < 21) {
        fill(255, 59, 59);
      } else if (i > 0 && i < 28) {
        fill(42, 128, 209);
      }

      rect(x, y, blockWidth, blockHeight, 10);
      // Collision with the ball
      if (
        ballX + ballRadius > x &&
        ballX - ballRadius < x + blockWidth &&

        ballY + ballRadius > y &&
        ballY - ballRadius < y + blockHeight
        ) {

        if (blockCollisionDebounce) {
          return;
        }

        // Bounce the ball
        ballSpeedY = -ballSpeedY;

        // Destroy the block
        blockAlive[i] = false;
        blockCount -= 1;
        blockCollisionDebounce = true;
        lastBlockCollision = millis();
        score += blockPointsWorth;

        println("Block count: " + blockCount);

        // Player got all the blocks
        if (blockCount <= 0) {
          blockCount = 0;
          resetBlocks();
        }
        break;
      }
    }

    if (gameOver) {
      background(20);
      fill(120);
      rect(150, 150, 300, 350, 12);

      fill(0);
      textSize(48);
      text("GAME OVER", 175, 32);
    }
    // Score Text
    textSize(48);
    fill(255);
    text("Score: " + score, 40, 560);
  }
}

// Paddle movement
void keyPressed() {
  // Move the paddle right
  if (key == 'd' || keyCode == RIGHT) {
    rightPressed = true;
  } else if (key == 'a' || keyCode == LEFT) {
    // Move it left
    leftPressed = true;
  }
}

void keyReleased() {
  if (key == 'a' || key == LEFT) {
    leftPressed = false;
  } else if (key == 'd' || key == RIGHT) {
    rightPressed = false;
  }
}

void mousePressed() {
  if (roundStarted) {
    return;
  }
  if (mouseX >= startButtonX &&
    mouseX <= startButtonX + startButtonWidth &&
    mouseY >= startButtonY &&
    mouseY <= startButtonY + startButtonHeight) {
    roundStarted = true;
  }
}
