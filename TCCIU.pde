int menuIndex = 0, menuMinigamesIndex = 0, menuOptionsIndex= 0, menuUserIndex = 0;
int maxMenu = 6,   maxMinigames = 3,       maxOptions = 3,      maxUser = 0;
int menuSelected = -1;
/*
-1 = Menu principal
 0  = Menu minijuegos
 1  = Menu de editar usuario
 2  = Menu de cambiar usuario
 3  = Menu de opciones
 4  = Salir
 */

int numberOfGames = 3;
MiniGame[] gameList = new MiniGame[numberOfGames];
String[] gameListScoreText = new String[numberOfGames];
int[] gameScore = new int[numberOfGames];


int maxPalette = 4;
Palette[] palettes = new Palette[maxPalette];
String[] palettesText = new String[maxPalette];


boolean userLogged = false;
boolean inGame = false;


JSONArray appData;
String dataPath;
ManageUser mg;
User currentUser;
String userName = "";

int barLimit = 300;
int volume = 50, sound = 50, palette = 0;
boolean volumeOption = false, soundOption = false, paletteOption = false, fontOption = false;

void setup() {
  size(1280, 720);
  stroke(15);

  dataPath = "data/users.json";
  appData = loadJSONArray(dataPath);
  mg = new ManageUser(appData, dataPath);
  
  palettes[0] = new Palette("img/palette/plantilla1.png", 0, 0, 0);
  palettesText[0] = "Normal";
  palettes[1] = new Palette("img/palette/plantilla2.png", 0, 0, 0);
  palettesText[1] = "Frios";
  palettes[2] = new Palette("img/palette/plantilla3.png", 0, 0, 0);
  palettesText[2] = "Calidos";
  palettes[3] = new Palette("img/palette/plantilla4.png", 255, 255, 255);
  palettesText[3] = "Invertido";

  gameList[0] = new Sudoku("Sudoku", palettes[0]);
  gameListScoreText[0] = "Segundos";
  gameList[1] = new Memory("Memory", new Pulse(this));
  gameListScoreText[1] = "Racha de";
  gameList[2] = new CoinChange("Coins");
  gameListScoreText[2] = "Segundos";

  
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
      gameList[menuMinigamesIndex].display(palettes[palette], volume, sound);
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
  if(!inGame){
    fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
    textSize(20);
    text("Usa las flechas arriba y abajo para\nmoverte por los distintos menus.\nPulsa las flechas izquierda y\nderecha para aumentar o disminuir\nlas opciones que lo requieran\nPulsa ENTER para acceder al\nmenu o juego\nPulsa RETROCESO para volver al\nmenu", 915, 40);
  }
  popMatrix();
}

void displayUser() {
  pushMatrix();
  PImage img = loadImage(currentUser.getProfileImage());
  img.resize(350, 350);
  rect(908,318,352,352);
  image(img, 910,320);
  textSize(30);
  text(currentUser.getName(),910,710);
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
  currentUser.setPreference(volume, "Volume");
  currentUser.setPreference(sound, "Sound");
  currentUser.setPreference(palette, "Palette");
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
  stroke(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  rect(240, 265+menuIndex*40, 300, 45);
}



void displayMinigames() {
  textSize(30);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  text("Puntuación", 440, 260);
  for (int i = 0; i < numberOfGames; i++) {
    String gameName = gameList[i].getGameName();
    int gameScore = currentUser.getScoreOf(gameName);
    text(gameName, 250, 300+40*i);
    if ( gameScore == -1) {
      text(" -", 440, 300+40*i);
    } else {
      if(i == 1){
        text(gameListScoreText[i]+" "+abs(gameScore), 440, 300+40*i);
      } else {
        text(abs(gameScore)+" "+gameListScoreText[i], 440, 300+40*i);
      }  
    }
  }


  displayMinigameBox();
}
void displayMinigameBox() {
  noFill();
  strokeWeight(5);
  stroke(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  rect(240, 265+menuMinigamesIndex*40, 150, 45);
}


void displayOptions() {
  textSize(40);
  text("Opciones", 320, 250);
  textSize(30);
  text("Volumen de musica", 250, 300);
  textSize(20);
  text("<-",250,337);
  text("->",250+50+barLimit,337);
  noFill();
  rect(290, 320, barLimit, 20);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  rect(290, 320, volume*3, 20);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);  textSize(30);
  
  text("Volumen de sonido", 250, 390);
  textSize(20);
  text("<-",250,427);
  text("->",250+50+barLimit,427);
  noFill();
  rect(290, 410, barLimit, 20);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  rect(290, 410, sound*3, 20);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  textSize(30);
  text("Cambiar paleta de colores", 250, 480);
  textSize(20);
  text("<-  "+palettesText[palette]+ "  ->",250,520);
  displayOptionsBox();
}

void displayOptionsBox() {
  noFill();
  stroke(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  strokeWeight(5);
  if (menuOptionsIndex == 0) {
    rect(240, 265, 390, 45);
    volumeOption = true;
    soundOption = false;
    paletteOption = false;
  } else if (menuOptionsIndex == 1) {
    rect(240, 315+menuOptionsIndex*40, 390, 45);
    volumeOption = false;
    soundOption = true;
    paletteOption = false;
    
  } else if (menuOptionsIndex == 2){
    //Opciones para paleta y fuente
    rect(240, 365+menuOptionsIndex*40, 390, 45);
    volumeOption = false;
    soundOption = false;
    paletteOption = true;
  } else {
    rect(240, 355+menuOptionsIndex*40, 390, 45);
    volumeOption = false;
    soundOption = false;
    paletteOption = false;
  }
}

void displayCredits() {
  textSize(40);
  textAlign(CENTER);
  text("Aplicación desarrollada por:", 450, 250);
  strokeWeight(5);
  textSize(30);
  textAlign(CENTER);
  text("Yone Hernández León\nCarlos Javier Martín Perdomo\nFrancisco Jose Santana Sosa\n\nCon la colaboración musical de:\nNicolás Almeida Ramírez", 450, 300);
  textAlign(LEFT);
}



/*

 ------------------------------------- CONTROLES -------------------------------------
 
 */


void currentIndexUp() {
  switch(menuSelected) {
  case -1:
    menuIndex--;
    if (menuIndex == -1) {
      menuIndex = maxMenu-1;
    } 
    break;
  case 0:
    menuMinigamesIndex--;
    if (menuMinigamesIndex == -1) {
      menuMinigamesIndex = maxMinigames-1;
    }
    break;
  case 3:
    menuOptionsIndex--;
    if (menuOptionsIndex == -1) {
      menuOptionsIndex = maxOptions-1;
    }
    break;
  }
}

void currentIndexDown() {
  switch(menuSelected) {
  case -1:
    menuIndex++;

    if (menuIndex == maxMenu) {
      menuIndex = 0;
    } 
    break;
  case 0:
    menuMinigamesIndex++;
    if (menuMinigamesIndex == maxMinigames) {
      menuMinigamesIndex = 0;
    }
    break;
  case 3:
    menuOptionsIndex++;
    if (menuOptionsIndex == maxOptions) {
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
        
        if(keyCode == LEFT && soundOption){
          sound--;
          if(sound<0){sound=0;}
        }
        if(keyCode == RIGHT && soundOption){
          sound++;
          if(sound>100){sound=100;}
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
      volume = currentUser.getPreference("Volume");
      sound = currentUser.getPreference("Sound");
      palette = currentUser.getPreference("Palette");
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
    currentUser.setPreference(volume, "Volume");
    currentUser.setPreference(sound, "Sound");
    currentUser.setPreference(palette, "Palette");
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
