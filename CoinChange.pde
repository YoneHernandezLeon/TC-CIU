class CoinChange extends MiniGame {

  private final int dim = 100;
  private final int[][] pcoins = {{483, 504}, {483, 648}, {649, 504}, {649, 648}, {815, 504}, {815, 648}};
  private final int[][] presult = {{483, 108}, {483, 324}, {649, 108}, {649, 324}, {815, 108}, {815, 324}};
  private final int[][] offset = {{-20, -20}, {20, -20}, {-20, 20}, {20, 20}, {0, 0}};

  private final String[] coinLabel = {"2€", "1€", "50c", "20c", "10c", "5c"};

  private int[] coins;
  private float price;
  private int paid, paidCount, level, maxLevel;

  private boolean startTimer = true, failAdded = false;
  private int startTime, h, m, s, fallos;
  private String ohs="00", oms="00", oss="00";
  private String hs="00", ms="00", ss="00";
  
  PImage howto;

  CoinChange(String name) {
    this.score = 0;
    this.gameName = name;
    this.maxLevel = 7;

    coins = new int[6];
    this.setStartValues();
    howto = loadImage("img/howto/coinimg.png");
    howto.resize(426, 240);
  }

  void reset() {
    print("reset\n");
    super.reset();

    score = 0;
    level = 0;
    fallos = 0;
    startTime = 0;
    startTimer = true;
    failAdded = false;
    setStartValues();
  }

  void endGame() {
    pushMatrix();
    textSize(30);
    if (!failAdded){
      score += fallos * 10;
      ohs = hs;
      oms = ms;
      oss = ss;
      failAdded = true;
    }
    text("Tiempo acumulado: " +ohs+":"+oms+":"+oss, 100, 250);
    text("Fallos cometidos: " + fallos, 100, 290);

    text("Tiempo acumulado por fallos cometidos:\n" + fallos + " fallos x 10 segundos = " + fallos * 10 + " segundos", 100, 330);

    s = score;
    h = 0;
    while (s >= 3600) {
      h++;
      if (h<10) {
        hs = "0"+h;
      } else {
        hs = ""+h;
      }
      s -= 3600;
    }
    m = 0;
    while (s >= 60) {
      m++;
      if (m<10) {
        ms = "0"+m;
      } else {
        ms = ""+m;
      }
      s -= 60;
    }
    if (s<10) {
      ss = "0"+s;
    } else {
      ss = ""+s;
    }
    
    text("Tiempo final: "+hs+":"+ms+":"+ss, 100, 420);
    text("Pulsa retroceso para volver al menu",15,700);
    popMatrix();
  }

  void controlDisplay() {
    //rect(910,20,350,290);
    pushMatrix();
    fill(0);
    textSize(20);
    textAlign(LEFT);
    text("Click izquierdo sobre una moneda\npara añadirla al bote.\nClick derecho sobre una moneda\npara retirarla del bote.\nPulsa espacio para confirmar\nel cambio.\n\nPulsa RETROCESO para abandonar\nla partida y volver al menu.", 915, 45);

    popMatrix();
  }

  boolean isGameFinished() {
    return score != 0;
  }

  void howToPlay() {
    pushMatrix();
    fill(0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("CAMBIO DE MONEDAS", 450, 60);
    textSize(30);
    textAlign(LEFT);
    text("Instrucciones", 15, 140);
    textSize(20);
    text(
      "-Este minijuego consiste en entregar (en monedas) el camio exacto al cliente, quien\npagará siempre con billetes de 5, 10 y 20€\n"+
      "-En la parte izquierda del juego encontrarás el precio que tiene que pagar el cliente\n(arriba) y los billetes con los que paga (abajo).\n"+
      "-En la parte derecha del juego encontrarás el bote con las monedas seleccionadas (arriba)\ny los botones para añadir o retirar monedas (abajo).\n"+
      "-Tu puntuacion final sera el tiempo que has tardado en completar 7 casos mas una\npenalizacion por cada fallo cometido.\n"
      , 15, 180);
    image(howto, 237, 420);
    text("Pulsa enter para comenzar", 15, 700);
    text("Pulsa retroceso para volver al menu", 540, 700);
    popMatrix();
    controlDisplay();
  }

  void inGame() {
    if (level < maxLevel) {
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
      textSize(20);
      text("Caso " + (level + 1) + "/" + maxLevel, 850, 20);
      textSize(40);
      popMatrix();

      displayBills();
      displayCoins();
    } else {
      if (level == maxLevel) {
        score = (millis()-startTime)/1000;
        s = score;
        h = 0;
        while (s >= 3600) {
          h++;
          if (h<10) {
            hs = "0"+h;
          } else {
            hs = ""+h;
          }
          s -= 3600;
        }
        m = 0;
        while (s >= 60) {
          m++;
          if (m<10) {
            ms = "0"+m;
          } else {
            ms = ""+m;
          }
          s -= 60;
        }
        if (s<10) {
          ss = "0"+s;
        } else {
          ss = ""+s;
        }
        
        level ++;
      }
      endGame();
    }
    controlDisplay();
  }

  void setStartValues() {
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
        while (true) {
          paid = (int)random(i, 11) * 5;
          paidCount = paid/5 - 1;
          if (paid - price <= 19.25) {
            break;
          }
        }
        break;
      }
    }
  }

  void display() {
    if (start) {
      if (timerFinished) {
        if (startTimer) {
          startTime = millis();
          startTimer = false;
        }
        inGame();
      } else {
        countDown();
      }
    } else {
      howToPlay();
    }
  }

  void control(int keyPress) {
    if (keyPress == ' ') {
      calculate();
    } else if (keyPress == ENTER) {
      if (!start) {
        millis = millis();
        start = true;
      }
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
    pushMatrix();
    float res = coins[0] * 2 + coins[1] + coins[2] * 0.5 + coins[3] * 0.2 + coins[4] * 0.1 + coins[5] * 0.05;
    textAlign(CENTER, CENTER);
    if (res + price == paid) {
      level++;
      setStartValues();
    } else {
      fallos++;
    }
    popMatrix();
  }
}
