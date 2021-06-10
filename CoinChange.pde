class CoinChange extends MiniGame {
  
  //Variables para el manejo y creación de monedas
  private final int dim = 100;
  private final int[][] pcoins = {{483, 504}, {483, 648}, {649, 504}, {649, 648}, {815, 504}, {815, 648}};
  private final int[][] presult = {{483, 108}, {483, 324}, {649, 108}, {649, 324}, {815, 108}, {815, 324}};
  private final int[][] offset = {{-20, -20}, {20, -20}, {-20, 20}, {20, 20}, {0, 0}};
  private int[] coins;
  
  //Variables para el manejo y creación del juego
  private float price;
  private int paid, paidCount, level, maxLevel, palette;

  //Variables para el control del tiempo de juego
  private boolean startTimer = true, failAdded = false;
  private int startTime, h, m, s, fallos;
  private String ohs="00", oms="00", oss="00";
  private String hs="00", ms="00", ss="00";
  
  //Variables para las texturas de monedas y billetes
  private PImage e50tex, e20tex, e10tex, e5tex, e2tex, e1tex, c50tex, c20tex, c10tex, c5tex;
  
  //Variables de las figuras de monedas y billetes
  private PShape e50, e20, e10, e5;
  private PShape[] cshapes = new PShape[6];
  
  //Paleta acutal del programa
  private Palette p;
  
  //Shader
  private PShader[] sh;
  
  //Imagen del menú de instrucciones
  PImage howto;
  
  //Variables para el manejo de sonido
  SoundFile acierto, error, level_complete, minigame;
  
  CoinChange(String name, int max, SoundFile S321, SoundFile Ya, SoundFile acierto, SoundFile error, SoundFile level_complete, SoundFile minigame) {
    this.S321 = S321;
    this.Ya = Ya;
    this.acierto = acierto;
    this.error = error;
    this.level_complete = level_complete;
    this.minigame = minigame;
    
    this.score = 0;
    this.gameName = name;
    this.maxLevel = 7;
    
    e50tex = loadImage("img/money/50e.png");
    e20tex = loadImage("img/money/20e.png");
    e10tex = loadImage("img/money/10e.png");
    e5tex = loadImage("img/money/5e.png");
    e2tex = loadImage("img/money/2e.png");
    e1tex = loadImage("img/money/1e.png");
    c50tex = loadImage("img/money/50c.png");
    c20tex = loadImage("img/money/20c.png");
    c10tex = loadImage("img/money/10c.png");
    c5tex = loadImage("img/money/5c.png");

    e50 = createBill(e50tex);
    e20 = createBill(e20tex);
    e10 = createBill(e10tex);
    e5 = createBill(e5tex);
    cshapes[0] = createCoin(e2tex);
    cshapes[1] = createCoin(e1tex);
    cshapes[2] = createCoin(c50tex);
    cshapes[3] = createCoin(c20tex);
    cshapes[4] = createCoin(c10tex);
    cshapes[5] = createCoin(c5tex);

    coins = new int[6];
    this.setStartValues();
    howto = loadImage("img/howto/coinimg.png");
    howto.resize(300, 240);
    
    sh = new PShader[max];
    for(int i = 0; i < max; i++){
      sh[i] = loadShader("shaders/texfrag" + i + ".glsl", "shaders/texvert.glsl");
    }
  }

  void reset() {
    super.reset();

    score = 0;
    level = 0;
    fallos = 0;
    startTime = 0;
    h = 0;
    m = 0;
    s = 0;
    startTimer = true;
    failAdded = false;
    setStartValues();
    
    minigame.stop();
    resetShader();
  }

  void endGame() {
    pushMatrix();
    textSize(30);
    if (!failAdded){
      level_complete.play();
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
    text("Pulsa retroceso para volver al menú",15,700);
    popMatrix();
  }

  void controlDisplay() {
    pushMatrix();
    fill(p.r, p.g, p.b);
    textSize(20);
    textAlign(LEFT);
    text("Click izquierdo sobre una moneda\npara añadirla al bote.\nClick derecho sobre una moneda\npara retirarla del bote.\nPulsa espacio para confirmar\nel cambio.\n\nPulsa RETROCESO para abandonar\nla partida y volver al menú.", 915, 45);

    popMatrix();
  }

  boolean isGameFinished() {
    return score != 0;
  }

  void howToPlay() {
    pushMatrix();
    fill(p.r, p.g, p.b);
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
      "-Tu puntuacion final será el tiempo que has tardado en completar 7 casos más una\npenalización por cada fallo cometido.\n"
      , 15, 180);
    image(howto, 300, 420);
    text("Pulsa enter para comenzar", 15, 700);
    text("Pulsa retroceso para volver al menú", 540, 700);
    popMatrix();
    controlDisplay();
  }

  void inGame() {
    if (level < maxLevel) {
      line(400, 0, 400, 720);
      line(0, 124, 400, 124);
      line(0, 248, 400, 248);
      line(400, 432, 900, 432);

      pushMatrix();
      fill(p.r, p.g, p.b);
      textSize(40);
      textAlign(CENTER, CENTER);
      text("Calcula el cambio:", 200, 60);
      text(price + " €", 200, 182);
      textSize(20);
      text("Caso " + (level + 1) + "/" + maxLevel, 850, 20);
      textSize(40);
      popMatrix();

      noStroke();
      shader(sh[palette]);
      displayBills();
      displayCoins();
      resetShader();
      stroke(p.r, p.g, p.b);
      
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

  //Reinicia los valores para cada caso nuevo del minijuego de manera aleatoria
  void setStartValues() {
    for (int i = 0; i < 6; i++) {
      coins[i] = 0;
    }
    price = parseFloat(nf(random(2, 47), 0, 1).replace(',', '.'));
    if (random(1) > 0.5) {
      price += 0.05;
      price = (float) round(price * 100) / 100;
    }
    for (int i = 1; i <= 10; i++) {
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

  void display(Palette p, int palette, int volume, int sound) {
    if(!minigame.isPlaying()){minigame.loop();}
    this.p = p;
    this.palette = palette;
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
    if (keyPress == ' ' && level != maxLevel) {
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

  //Añade y elimina monedas, y controla que la cantidad de monedas de cada tipo no supere las 5 monedas
  private void manageCoins(int coin, boolean add) {
    if (add && coins[coin] < 5) {
      coins[coin]++;
    } else if (!add && coins[coin] > 0) {
      coins[coin]--;
    }
  }

  //Muestra el precio pagado por el cliente en billetes
  private void displayBills() {
    pushMatrix();
    noFill();
    textAlign(CENTER, CENTER);
    switch(paidCount) {
    case 0:
      shape(e5, 70, 409);
      break;
    case 1:
      shape(e10, 70, 409);
      break;
    case 2:
      shape(e10, 20, 299);
      shape(e5, 120, 519);
      break;
    case 3:
      shape(e20, 70, 409);
      break;
    case 4:
      shape(e20, 20, 299);
      shape(e5, 120, 519);
      break;
    case 5:
      shape(e20, 20, 299);
      shape(e10, 120, 519);
      break;
    case 6:
      shape(e20, 20, 259);
      shape(e10, 70, 414);
      shape(e5, 120, 569);
      break;
    case 7:
      shape(e20, 20, 299);
      shape(e20, 120, 519);
      break;
    case 8:
      shape(e20, 20, 259);
      shape(e20, 70, 414);
      shape(e5, 120, 569);
      break;
    case 9:
      shape(e50, 70, 409);
      break;
    }
    popMatrix();
  }

  //Muestra tanto los botones de cada moneda como las monedas de cada tipo del cambio que se va a entregar
  private void displayCoins() {
    pushMatrix();
    textSize(30);
    for (int i = 0; i < coins.length; i++) {
      for (int j = 0; j < coins[i]; j++) {
        shape(cshapes[i], presult[i][0] + offset[j][0] - 50, presult[i][1] + offset[j][1] - 50);
      }
      shape(cshapes[i], pcoins[i][0] - 50, pcoins[i][1] - 50);
    }
    popMatrix();
  }

  //Calcula si el cambio ofrecido es el exacto
  private void calculate() {
    pushMatrix();
    float res = coins[0] * 2 + coins[1] + coins[2] * 0.5 + coins[3] * 0.2 + coins[4] * 0.1 + coins[5] * 0.05;
    textAlign(CENTER, CENTER);
    if (res + price == paid) {
      acierto.play();
      level++;
      setStartValues();
    } else {
      error.play();
      fallos++;
    }
    popMatrix();
  }
  
  //Inicializa las figuras de las monedas
  private PShape createCoin(PImage i){
    noStroke();
    i.resize(dim, dim);
    PShape p = createShape(RECT, 0, 0, dim, dim);
    beginShape();
    p.setTexture(i);
    endShape();
    return p;
  }
  
  //Inicializa las figuras de los billetes
  private PShape createBill(PImage i){
    PShape p = createShape(RECT, 0, 0, 260, 140);
    beginShape();
    p.setTexture(i);
    endShape();
    return p;
  }
}
