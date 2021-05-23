class CoinChange extends MiniGame {
  /*
  private final int twoD = 100;
   private final int oneD = 90;
   private final int fiftyD = 95;
   private final int twentyD = 80;
   private final int tenD = 70;
   private final int fiveD = 75;
   */

  private final int dim = 100;
  private final int[][] pcoins = {{483, 504}, {483, 648}, {649, 504}, {649, 648}, {815, 504}, {815, 648}};
  private final int[][] presult = {{483, 108}, {483, 324}, {649, 108}, {649, 324}, {815, 108}, {815, 324}};
  private final int[][] offset = {{-20, -20}, {20, -20}, {-20, 20}, {20, 20}, {0, 0}};

  private final String[] coinLabel = {"2€", "1€", "50c", "20c", "10c", "5c"};

  private int[] coins;
  private float price;
  private int paid, paidCount;

  CoinChange(String gameName) {
    this.gameName = gameName;
    this.score = 0;

    coins = new int[6];
    for (int i = 0; i < 6; i++) {
      coins[i] = 0;
    }
    price = parseFloat(nf(random(2, 47), 0, 1).replace(',', '.'));
    if (random(1) > 0.5) {
      price += 0.05;
      price = (float) round(price * 100) / 100;
    }
    for (int i = 1; i < 10; i++) {
      if (price < i * 5) {
        while(true) {
          paid = (int)random(i, 11) * 5;
          paidCount = paid/5 - 1;
          if(paid - price <= 19.25){
            break;
          }
        }
        break;
      }
    }
  }
  
  void howToPlay(){
  }
  
  void inGame(){
  }

  void display() {
    fill(255);
    noStroke();
    rect(0, 0, 900, 720);

    stroke(15);
    line(400, 0, 400, 720);
    line(0, 124, 400, 124);
    line(0, 248, 400, 248);
    line(400, 432, 900, 432);

    pushMatrix();
    fill(0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("Calcula el cambio:", 200, 60);
    text(price + " €", 200, 182);
    /*
    circle(525, 528, twoD);
     circle(525, 640, oneD);
     circle(650, 528, fiftyD);
     circle(650, 640, twentyD);
     circle(775, 528, tenD);
     circle(775, 640, fiveD);
     */
    popMatrix();

    displayBills();
    displayCoins();
  }

  void control(int keyPress) {
    if (keyPress == 32) {
      calculate();
    }
  }

  void control(int x, int y, boolean left) {
    if (x < 400 || x > 900 || y < 432) {
      return;
    }

    if (abs(sqrt(sq(abs(x - pcoins[0][0])) + sq(abs(y - pcoins[0][1])))) < dim/2) {
      manageCoins(0, left);
    }
    if (abs(sqrt(sq(abs(x - pcoins[1][0])) + sq(abs(y - pcoins[1][1])))) < dim/2) {
      manageCoins(1, left);
    }
    if (abs(sqrt(sq(abs(x - pcoins[2][0])) + sq(abs(y - pcoins[2][1])))) < dim/2) {
      manageCoins(2, left);
    }
    if (abs(sqrt(sq(abs(x - pcoins[3][0])) + sq(abs(y - pcoins[3][1])))) < dim/2) {
      manageCoins(3, left);
    }
    if (abs(sqrt(sq(abs(x - pcoins[4][0])) + sq(abs(y - pcoins[4][1])))) < dim/2) {
      manageCoins(4, left);
    }
    if (abs(sqrt(sq(abs(x - pcoins[5][0])) + sq(abs(y - pcoins[5][1])))) < dim/2) {
      manageCoins(5, left);
    }
  }

  private void manageCoins(int coin, boolean add) {
    if (add && coins[coin] < 5) {
      coins[coin]++;
    } else if (!add && coins[coin] > 0) {
      coins[coin]--;
    }
  }

  private void displayBills() {
    pushMatrix();
    noFill();
    textAlign(CENTER, CENTER);
    switch(paidCount) {
    case 0:
      rect(70, 419, 260, 130);
      fill(0);
      text("5€", 200, 484);
      break;
    case 1:
      rect(70, 419, 260, 130);
      fill(0);
      text("10€", 200, 484);
      break;
    case 2:
      rect(20, 309, 260, 130);
      rect(120, 529, 260, 130);
      fill(0);
      text("10€", 150, 374);
      text("5€", 250, 594);
      break;
    case 3:
      rect(70, 419, 260, 130);
      text("20€", 200, 484);
      break;
    case 4:
      rect(20, 309, 260, 130);
      rect(120, 529, 260, 130);
      fill(0);
      text("20€", 150, 374);
      text("5€", 250, 594);
      break;
    case 5:
      rect(20, 309, 260, 130);
      rect(120, 529, 260, 130);
      fill(0);
      text("20€", 150, 374);
      text("10€", 250, 594);
      break;
    case 6:
      rect(20, 269, 260, 130);
      rect(70, 419, 260, 130);
      rect(120, 569, 260, 130);
      fill(0);
      text("20€", 150, 334);
      text("10€", 200, 484);
      text("5€", 250, 634);
      break;
    case 7:
      rect(20, 309, 260, 130);
      rect(120, 529, 260, 130);
      fill(0);
      text("20€", 150, 374);
      text("20€", 250, 594);
      break;
    case 8:
      rect(20, 269, 260, 130);
      rect(70, 419, 260, 130);
      rect(120, 569, 260, 130);
      fill(0);
      text("20€", 150, 334);
      text("20€", 200, 484);
      text("5€", 250, 634);
      break;
    case 9:
      rect(70, 419, 260, 130);
      fill(0);
      text("50€", 200, 484);
      break;
    }
    popMatrix();
  }

  private void displayCoins() {
    pushMatrix();
    textSize(30);
    for (int i = 0; i < coins.length; i++) {
      for (int j = 0; j < coins[i]; j++) {
        fill(240, 230, 140);
        circle(presult[i][0] + offset[j][0], presult[i][1] + offset[j][1], dim);
        fill(0);
        text(coinLabel[i], presult[i][0] + offset[j][0], presult[i][1] + offset[j][1]);
      }
      fill(240, 230, 140);
      circle(pcoins[i][0], pcoins[i][1], dim);
      fill(0);
      text(coinLabel[i], pcoins[i][0], pcoins[i][1]);
    }
    popMatrix();
  }

  private void calculate() {
    float res = coins[0] * 2 + coins[1] + coins[2] * 0.5 + coins[3] * 0.2 + coins[4] * 0.1 + coins[5] * 0.05;
    pushMatrix();
    textAlign(CENTER, CENTER);
    popMatrix();
    if (res + price == paid) {
      text("Ganaste", 1000, 360);
    }
  }
}
