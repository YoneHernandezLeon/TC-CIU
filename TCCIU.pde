int numberOfGames = 3, menuIndex = 0, menuMinigamesIndex = 0, menuOptionsIndex= 0, menuUserIndex = 0, maxPalette = 4;
int menuSelected = -1;
/*
-1 = Menu principal
 0  = Menu minijuegos
 1  = Menu de editar usuario
 2  = Menu de cambiar usuario
 3  = Menu de opciones
 4  = Salir
 */

MiniGame[] gameList = new MiniGame[numberOfGames];
Palette[] palettes = new Palette[maxPalette];
int[] gameScore = new int[numberOfGames];

boolean userLogged = false;
boolean inGame = false;
String userName = "";

JSONArray appData;
String dataPath;
ManageUser mg;
User currentUser;

int barLimit = 300, volume = 50, palette = 0;
boolean volumeOption = false, paletteOption = false, fontOption = false;

void setup() {
  size(1280, 720);
  stroke(15);

  dataPath = "data/users.json";
  appData = loadJSONArray(dataPath);
  mg = new ManageUser(appData, dataPath);

  gameList[0] = new Sudoku("Sudoku");
  gameList[1] = new Memory("Memory", new Pulse(this));
  gameList[2] = new CoinChange("Coins");

  palettes[0] = new Palette("img/palette/plantilla1.png", 0, 0, 0);
  palettes[1] = new Palette("img/palette/plantilla2.png", 0, 0, 0);
  palettes[2] = new Palette("img/palette/plantilla3.png", 0, 0, 0);
  palettes[3] = new Palette("img/palette/plantilla4.png", 255, 255, 255);
}

void draw() {
  background(palettes[palette].img);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  textAlign(LEFT);
  if (userLogged) {
    displayRightPanel();
    if (!inGame) {
      displayTitle();
      switch(menuSelected) {
      case -1:
        displayMainMenu();
        break;
      case 0:
        displayMinigames();
        break;
      case 1:
        displayEditUser();
        break;
      case 2:
        //resetear usuario
        changeUser();
        break;
      case 3:
        displayOptions();
        break;
      case 4:
        displayCredits();
        break;
      case 5:
        exit();
        break;
      }
    } else {
      gameList[menuMinigamesIndex].display();
    }
  } else {
    displayLogin();
  }
}


/*

 ------------------------------------- DISPLAYS COMUNES -------------------------------------
 
 */

void displayRightPanel() {
  line(900, 0, 900, 720);
  displayControlBox();
  displayUser();
}

void displayControlBox() {
  pushMatrix();
  noFill();
  rect(910, 20, 350, 290);

  popMatrix();
}

void displayUser() {
  pushMatrix();
  noFill();
  rect(910, 320, 350, 350);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  textSize(30);
  text(currentUser.getName(), 910, 710); // AQUI VA EL NOMBRE DEL USUARIO
  popMatrix();
}

void displayTitle() {
  textSize(50);
  text("Titulo del juego", 250, 100);
}

void displayLogin() {
  background(0);
  fill(255);
  textSize(25);
  text("Escribe el nombre de usuario", 400, 300);
  text(userName, 400, 340);
  //Crear o cargar usuario
  //Iterar sobre gameScore para cargar puntuaciones mas altas
}


void displayEditUser() {
  text("Cambiar imagen", 250, 340);
}

void changeUser() {
  //Guardar usuario
  userName = "";
  userLogged = false;
  mg.saveUser(currentUser);
  resetMenu();
}


/*

 ------------------------------------- DISPLAYS ESPECIFICOS -------------------------------------
 
 */

void displayMainMenu() {
  textSize(30);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  text("Minijuegos", 250, 300);
  text("Editar usuario", 250, 340);
  text("Cambiar usuario", 250, 380);
  text("Opciones", 250, 420);
  text("Creditos", 250, 460);
  text("Salir", 250, 500);
  displayMainBox();
}
void displayMainBox() {
  noFill();
  strokeWeight(5);
  rect(240, 265+menuIndex*40, 300, 45);
}



void displayMinigames() {
  textSize(30);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  text("P.A.", 440, 260);
  for (int i = 0; i < numberOfGames; i++) {
    String gameName = gameList[i].getGameName();
    int gameScore = currentUser.getScoreOf(gameName);
    text(gameName, 250, 300+40*i);
    if ( gameScore == -1) {
      text(" -", 440, 300+40*i);
    } else {
      text(abs(gameScore), 440, 300+40*i);
    }
  }
  text("P.A. = puntuacion maxima actual para cada minijuego", 15, 700);


  displayMinigameBox();
}
void displayMinigameBox() {
  noFill();
  strokeWeight(5);
  rect(240, 265+menuMinigamesIndex*40, 300, 45);
}


void displayOptions() {
  textSize(40);
  text("Opciones", 320, 250);
  textSize(30);
  text("Volumen", 250, 300);
  noFill();
  rect(250, 320, barLimit, 20);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  rect(250, 320, volume*3, 20);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  text("Cambiar paleta de colores", 250, 390);
  text("Cambiar fuente de letra", 250, 430);
  displayOptionsBox();
}

void displayOptionsBox() {
  noFill();
  strokeWeight(5);
  if (menuOptionsIndex == 0) {
    rect(240, 265, 390, 45);
    volumeOption = true;
    paletteOption = false;
  } else if (menuOptionsIndex == 1) {
    //Opciones para paleta y fuente
    rect(240, 315+menuOptionsIndex*40, 390, 45);
    volumeOption = false;
    paletteOption = true;
  } else {
    rect(240, 315+menuOptionsIndex*40, 390, 45);
    volumeOption = false;
    paletteOption = false;
  }
}

void displayCredits() {
}



/*

 ------------------------------------- CONTROLES -------------------------------------
 
 */


void currentIndexUp() {
  switch(menuSelected) {
  case -1:
    menuIndex--;
    if (menuIndex == -1) {
      menuIndex = 5;
    } 
    break;
  case 0:
    menuMinigamesIndex--;
    if (menuMinigamesIndex == -1) {
      menuMinigamesIndex = 2;
    }
    break;
  case 3:
    menuOptionsIndex--;
    if (menuOptionsIndex == -1) {
      menuOptionsIndex = 2;
    }
    break;
  }
}

void currentIndexDown() {
  switch(menuSelected) {
  case -1:
    menuIndex++;

    if (menuIndex == 6) {
      menuIndex = 0;
    } 
    break;
  case 0:
    menuMinigamesIndex++;
    if (menuMinigamesIndex == 3) {
      menuMinigamesIndex = 0;
    }
    break;
  case 3:
    menuOptionsIndex++;
    if (menuOptionsIndex == 3) {
      menuOptionsIndex = 0;
    }
    break;
  }
}

void enterNewMenu() {
  switch(menuSelected) {
  case -1:
    menuSelected = menuIndex;
    break;
  case 0:
    inGame = true;
    break;
  case 1:
    if (menuUserIndex == 0) {
      //Borrar usuario
    } else {
      //Capturar imagen
    }
  }
}

void resetMenu() {

  gameList[menuMinigamesIndex].reset();
  menuIndex = 0;  
  menuMinigamesIndex = 0; 
  menuOptionsIndex= 0; 
  menuSelected = -1; 
  menuUserIndex = 0;
  inGame = false;
}

void keyPressed() {
  if (userLogged) {
    if (!gameList[menuMinigamesIndex].isInCountdown()) {
      if (inGame) { 
        gameList[menuMinigamesIndex].control(key);
      } else {
        if (keyCode == UP) {
          currentIndexUp();
        }

        if (keyCode == DOWN) {
          currentIndexDown();
        }

        if (keyCode == ENTER) {
          enterNewMenu();
        }
        
        if(keyCode == LEFT && volumeOption){
          volume--;
          if(volume<0){volume=0;}
        }
        if(keyCode == RIGHT && volumeOption){
          volume++;
          if(volume>100){volume=100;}
        }
        
        if(keyCode == LEFT && paletteOption){
          palette--;
          if(palette<0){palette=maxPalette - 1;}
        }
        if(keyCode == RIGHT && paletteOption){
          palette++;
          if(palette==maxPalette){palette = 0;}
        }
      }

      if (keyCode == BACKSPACE) {
        checkGame();
        resetMenu();
      }
    }
  } else {
    if (keyCode == ENTER && userName.length() > 0) {
      currentUser = mg.login(userName);
      userLogged = true;
    }

    if (keyCode == BACKSPACE && userName.length() > 0) {
      userName = userName.substring(0, userName.length() - 1);
    } else if (keyCode >= 32 && keyCode <= 94  && userName.length() < 26) {
      userName += key;
    }
  }
}
void mousePressed() {
  if (inGame) {
    gameList[menuMinigamesIndex].control(mouseX, mouseY, (mouseButton ==  LEFT));
  }
}


/*

 ------------------------------------- CONTROLES AUXILIARES -------------------------------------
 
 */

void checkGame() {
  if (inGame &&  gameList[menuMinigamesIndex].isGameFinished()) {
    println(gameList[menuMinigamesIndex].getScore());
    //if(gameScore[menuMinigamesIndex] < gameList[menuMinigamesIndex].getScore()){
    currentUser.setScoreOf(gameList[menuMinigamesIndex].getScore(), gameList[menuMinigamesIndex].getGameName());
    //}
  }
}

void exit() {
  if (currentUser != null) {
    mg.saveUser(currentUser);
  }
  super.exit();
}

class Palette {

  public PImage img;
  public int r, g, b;

  Palette(String i, int r, int g, int b) {
    this.img = loadImage(i);
    this.r = r;
    this.g = g;
    this.b = b;
  }
}
