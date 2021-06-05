class Sudoku extends MiniGame {

  int size = 9;
  int[][] solution = new int[size][size];
  int[][] current = new int[size][size];

  String originaPath = "Sudoku/Original.txt";
  String solvedPath = "Sudoku/Solved.txt";

  Piece[][] board = new Piece[size][size];
  Piece selected;

  int index;

  int fallos = 0; //TIEMPO

  boolean success;
  boolean gameFinished = false;
  boolean failAdded = false;

  int startTime, h, m, s;
  String ohs="00", oms="00", oss="00";
  String hs="00", ms="00", ss="00";
  boolean startTimer = true;
  
  Palette p;
  
  private PImage img0, img1;

  Sudoku(String gameName, Palette p) {
    score = 3600;
    this.gameName = gameName;
    this.p = p;
    
    img0 = loadImage("img/howto/sudokuImg0.jpeg");
    img0.resize(300, 240);
    img1 = loadImage("img/howto/sudokuImg1.jpeg");
    img1.resize(300, 240);
  }

  void reset() {
    super.reset();
    gameFinished = false;
    startTimer = true;
    startTime = 0;
    h=0; 
    m=0; 
    s=0;
    hs="00"; 
    ms="00"; 
    ss="00";
    ohs="00"; 
    oms="00"; 
    oss="00";
    fallos = 0;
    failAdded = false;
  }


  void controlDisplay() {
    //rect(910,20,350,290);
    pushMatrix();
    fill(p.r, p.g, p.b);
    textSize(20);
    text("Click izquierdo sobre una casilla\npara seleccionarla\n\nUsa los numeros del teclado\npara introducir un numero en\nla casilla seleccionada\n\nPulsa RETROCESO para abandonar\nla partida y volver al menu", 915, 45);

    popMatrix();
  }

  void endGame() {
    pushMatrix();
    textSize(30);
    if(!failAdded){
      ohs=hs; 
      oms=ms; 
      oss=ss;
      score = + score+(fallos*60);
      failAdded = true;
    }
    text("Tiempo acumulado: " +ohs+":"+oms+":"+oss, 100, 250);
    text("Vidas restantes: " + (5-fallos), 100, 290);

    text("Tiempo acumulado por vidas perdidas: " + fallos + " Minutos", 100, 330);

    
    
    s = score;
    h = 0;
    while (s >= 3600) {
      h++;
      s -= 3600;
    }
    if (h<10) {
      hs = "0"+h;
    } else {
      hs = ""+h;
    }
    
    m = 0;
    while (s >= 60) {
      m++;
      s -= 60;
    }
    if (m<10) {
      ms = "0"+m;
    } else {
      ms = ""+m;
    }
    
    if (s<10) {
      ss = "0"+s;
    } else {
      ss = ""+s;
    }
    text("Tiempo final: "+hs+":"+ms+":"+ss, 100, 370);
    text("Pulsa retroceso para volver al menu",15,700);
    popMatrix();
  }
  boolean isGameFinished(){
    return gameFinished;
  }

  void youLoose() {
    pushMatrix();
    textSize(50);
    text("HAS PERDIDO", 200, 310);
    textSize(20);
    text("Pulsa retroceso para volver al menu",15,700);
    popMatrix();
  }
  void display(Palette p, int palette, int volume, int sound) {
    this.p = p;
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


  void howToPlay() {
    pushMatrix();
    fill(p.r, p.g, p.b);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("SUDOKU", 450, 60);
    textSize(30);
    textAlign(LEFT);
    text("Instrucciones", 15, 140);
    textSize(20);
    text(
      "-Este minijuego consiste en colocar los numeros del 1 al 9 en cada fila, cada columna y en\ncada cuadrante 3x3. En cada una de estas designaciones los numero no se pueden repetir.\n"+
      "-Comienzas el juego con 5 vidas. Pierdes una vida cada vez que coloques un numero mal.\nSabras que un numero esta mal porque saldra en rojo. Si un numero sale en verde\nesto indica que es correcto.\n"+
      "-Si te quedas sin vidas pierdes. Si completas el sudoku con alguna vida restante tu\npuntuacion sera el tiempo que has tardado mas una penalizacion por las vidas perdidas.\n"
      , 15, 180);
    image(img0, 100, 420);
    image(img1, 500, 420);
    text("Pulsa enter para comenzar", 15, 700);
    text("Pulsa retroceso para volver al menu", 540, 700);
    popMatrix();
    controlDisplay();
  }

  void inGame() {
    if (!gameFinished) {
      if (fallos >= 5) {
        youLoose();
      } else {
        //Rectangulo blanco como fondo
        printBoard();
        printText();
        controlDisplay();
        checkFinished();
      }
    } else {
      endGame();
    }
  }

  void checkFinished() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (!board[i][j].getPieceEnded()) {
          gameFinished = false;
          return;
        }
      }
    }

    gameFinished = true;
  }

  void printBoard() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        board[i][j].display();
      }
    }
    pushMatrix();
    noFill();
    strokeWeight(5);
    stroke(p.r, p.g, p.b);
    rect(0, 90, 300, 210);
    rect(300, 90, 300, 210);
    rect(600, 90, 300, 210);
    rect(0, 300, 300, 210);
    rect(300, 300, 300, 210);
    rect(600, 300, 300, 210);
    rect(0, 510, 300, 210);
    rect(300, 510, 300, 210);
    rect(600, 510, 300, 210);
    popMatrix();
  }

  void printText() {
    pushMatrix();
    /*textSize(40);
     fill(255,0,0);
     text("Fallos: "+fallos, 20,65);
     fill(0,255,0);
     text("Aciertos: "+aciertos, 210,65);
     fill(0,0,255);
     text("Puntuación: "+score, 570,65);
     */


    score = (millis()-startTime)/1000 + 3400;
    s = score;
    h = 0;
    while (s >= 3600) {
      h++;
      s -= 3600;
    }
    if (h<10) {
      hs = "0"+h;
    } else {
      hs = ""+h;
    }
      
    m = 0;
    while (s >= 60) {
      m++;
      s -= 60;
    }
    if (m<10) {
      ms = "0"+m;
    } else {
      ms = ""+m;
    }
    
    if (s<10) {
      ss = "0"+s;
    } else {
      ss = ""+s;
    }

    fill(p.r, p.g, p.b);
    //fill(255, 0, 0);
    text("Vidas: "+(5-fallos), 20, 65);

    fill(p.r, p.g, p.b);
    //fill(0, 0, 255);
    text(hs+":"+ms+":"+ss, 650, 65);
    popMatrix();
  }

  

  void solve() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        board[i][j].setValue(solution[i][j]);
      }
    }
  }

  void control(int keyPress) {
    if (keyPress == ENTER) {
      if (!start) {
        millis = millis();
        start = true;
        loadSolution();
        loadCurrent();
        createBoard();
      } else {
        solve();
      }
    }
    if (keyPress <= 57 && keyPress >= 49) {
      try {
        switch(keyPress) {
        case 49:
          selected.setValue(1);
          println(1);
          break;
        case 50:
          selected.setValue(2);
          println(2);
          break;
        case 51:
          selected.setValue(3);
          println(3);
          break;
        case 52:
          selected.setValue(4);
          println(4);
          break;
        case 53:
          selected.setValue(5);
          println(5);
          break;
        case 54:
          selected.setValue(6);
          println(6);
          break;
        case 55:
          selected.setValue(7);
          println(7);
          break;
        case 56:
          selected.setValue(8);
          println(8);
          break;
        case 57:
          selected.setValue(9);
          println(9);
          break;
        }
        success = selected.getPieceEnded();
        if (!success && !gameFinished) {
          fallos++;
          println(fallos);
        }
      } 
      catch(NullPointerException e) {
      }
    }
  }

  void control(int x, int y, boolean left) {
    if (start) {
      if (left) {
        checkPosition(x, y);
      }
    }
  }


  void checkPosition(int x, int y) {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j].isInArea(x, y)) {
          if (selected != null) {
            selected.isNotClicked();
          }
          selected = board[i][j];
          break;
        }
      }
    }
  }



  void loadSolution() {
    String[] lines = loadStrings(originaPath);
    index = (int)(random(1, Integer.parseInt(lines[0].substring(0, lines[0].indexOf(";")))));

    int posI = 0;
    int start = 2+(index-1)*10;
    println("Solucion:");
    for (int i = start; i < start+9; i++) {
      for (int j = 0; j < 9; j++) {
        solution[posI][j] = Character.getNumericValue(lines[i].charAt(j));
        print(solution[posI][j]);
      }
      println();
      posI++;
    }
  }

  void loadCurrent() {
    String[] lines = loadStrings(solvedPath);

    int posI = 0;
    int start = 2+(index-1)*10;
    println("Original:");
    for (int i = start; i < start+9; i++) {
      for (int j = 0; j < 9; j++) {
        if (lines[i].charAt(j) == '.') {
          current[posI][j] = -1;
        } else { 
          current[posI][j] = Character.getNumericValue(lines[i].charAt(j));
        }
        print(current[posI][j]);
      }
      println();
      posI++;
    }
  }

  void createBoard() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        board[i][j] = new Piece(0+j*100, 90+i*70, 100, 70, current[i][j], solution[i][j], p);
      }
    }
  }
}










class Piece {
  int x, y, xWidth, yHeight, v, solution;
  boolean pieceEnded=false, isClicked = false, beginning;
  Palette p;

  Piece(int x, int y, int xWidth, int yHeight, int v, int solution, Palette p) {
    this.p = p;
    this.x = x;
    this.y = y;
    this.xWidth = xWidth;
    this.yHeight = yHeight;
    this.v = v;
    this.solution = solution;
    beginning = this.v == solution;
  }




  void display() {
    pushMatrix();
    noFill();
    stroke(100);
    strokeWeight(5);
    textSize(50);
    rect(x, y, xWidth, yHeight);
    if (beginning) {
      fill(p.r, p.g, p.b);
      text(""+v, x+0.35*xWidth, y+0.75*yHeight);
    } else {
      if (pieceEnded) {
        fill(0, 255, 0);
        text(""+v, x+0.35*xWidth, y+0.75*yHeight);
      } else {
        if (isClicked) {
          line(x+5, y+0.85*yHeight, x+xWidth-5, y+0.85*yHeight);
        }
        if (v == -1) {
          // Sin numero
        } else {
          if (v != solution) {
            // Numero mal
            fill(255, 0, 0);
            text(""+v, x+0.35*xWidth, y+0.75*yHeight);
          } else {
            //numero bien
            pieceEnded = true;
          }
        }
      }
    }
    popMatrix();
  }

  boolean isInArea(int xMouse, int yMouse) {
    if (!pieceEnded) {
      if ((xMouse>x && xMouse<x+xWidth) && (yMouse>y && yMouse<y+yHeight)) {
        isClicked = true;
        return true;
      }
    }
    return false;
  }

  void isNotClicked() {
    isClicked = false;
  }

  void setValue(int v) {
    if (!pieceEnded) {
      this.v = v;
    }
  }

  boolean getPieceEnded() {
    return v == solution;
  }
}
