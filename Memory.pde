import processing.sound.*;

class Memory extends MiniGame{
  
  boolean waiting, isGameLoose;
  int nSounds, streak;
  ArrayList<myKey> keyList;
  
  boolean displaySound, userKeyPress;
  int currentSounds, solvedSounds, pressedKey;
  int[] levelList;
  myKey currentKey;
  
  Pulse pulso;
  
  Memory(String gameName, Pulse pulso){
    this.gameName = gameName;
    this.pulso = pulso;
    
    waiting = false;
    nSounds = 1;
    streak = 0;
    currentSounds = 0;
    solvedSounds = 0;
    pressedKey = 0;
    displaySound = false;
    userKeyPress = false;
    isGameLoose = false;
    
    createKeyList();
  }
  
  void reset(){
    super.reset();
    waiting = false;
    nSounds = 1;
    streak = 0;
    currentSounds = 0;
    solvedSounds = 0;
    pressedKey = 0;
    displaySound = false;
    userKeyPress = false;
    isGameLoose = false;
  }
  
  void endGame(){
    fill(0);
    textSize(50);
    text("Has perdido con una racha de "+ streak,15,300);
    text("Pulsa retroceso para volver al menu",15,700);
  }
  
  void controlDisplay(){
    pushMatrix();
    fill(0);
    textSize(20);
    text("Click izquierdo sobre una tecla\npara seleccionarla como la\nsiguiente tecla de secuencia\n\nPulsa RETROCESO para abandonar\nla partida y volver al menu", 915, 40);
    popMatrix();
  }
  
  void display(){
    if(!isGameLoose){
      if(start){
        if (timerFinished){
          inGame();
        } else {
          countDown();
        }
      } else {
        howToPlay();
      }
    } else {
      endGame();
      
    }
  }
  
  
  void howToPlay(){
    pushMatrix();
    fill(0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("MEMORY",450,60);
    textSize(40);
    text("PRESIONA ENTER PARA COMENZAR",450,120);
    textSize(30);
    textAlign(LEFT);
    text("Instrucciones",15,170);
    textSize(20);
    text(
    "-Este minijuego consiste en escuchar y ver una secuencia de sonidos y luces y repetirla\npulsando las mismas teclas.\n"+
    "-La puntuacion del juego esta definida por el numero de secuencias seguidas que\naciertes.\n"+
    "-Tanto el sonido como la iluminacion se mantendran durante 1 segundo. Tras completar\ncorrectamente una secuencia habra una pausa de 1 segundo antes de comenzar la\nsiguiente.\n"
    ,15,210);
    text("Pulsa retroceso para volver al menu",15,700);
    popMatrix();
    controlDisplay();
  }
  
  void inGame(){
    displayKeyList();
    displayText();
    controlDisplay();
    
    
    if(displaySound){
      pulso.amp(0.5);
      pulso.freq(currentKey.getFreq());
      pulso.play();
      delay(1000);
      pulso.stop();
      
      currentKey.display(false);
      displaySound = false;
    }
    
    if(waiting){
      if(solvedSounds == nSounds){
        streak++;
        currentSounds = 0;
        waiting = false;
        nSounds++;
        delay(1000);
      } else {
        if(userKeyPress){
          if(pressedKey == levelList[solvedSounds]){
            userKeyPress = false;
            solvedSounds++;
          } else {
            isGameLoose = true;
          }
        }
      } 
    } else {
      if(currentSounds == nSounds){
        solvedSounds = 0;
        waiting = true;    
      } else {
        generateNext();
        //generando sonidos del nivel actual
      }
    }
  }
  
  void displayText(){
    pushMatrix();
    textSize(30);
    fill(0);
    text("Racha = "+streak,20,65);
    textSize(30);
    if(waiting){
      text("Pulsa las teclas en el orden correcto",350,65);  
    } else {
      text("Presta atencion a la secuencia",350,65);  
    }
    popMatrix();
  }
  
  void createKeyList(){
    keyList = new ArrayList<myKey>();
    //Dejando 10 a izq y der, cada pieza es 110 de ancho.
    /*keyList.add(new myKey(10,150,120,400,1,0,0,0,130));
    keyList.add(new myKey(10,400,120,650,2,23,32,42,140));
    keyList.add(new myKey(120,150,230,400,3,33,47,60,150));
    keyList.add(new myKey(120,400,230,650,4,66,73,73,160));
    keyList.add(new myKey(230,150,340,400,5,123,125,125,170));
    keyList.add(new myKey(230,400,340,650,6,220,118,51,180));
    keyList.add(new myKey(340,150,450,400,7,235,152,78,190));
    keyList.add(new myKey(340,400,450,650,8,244,208,63,200));
    keyList.add(new myKey(450,150,560,400,9,88,214,141,210));
    keyList.add(new myKey(450,400,560,650,10,82,190,128,220));
    keyList.add(new myKey(560,150,670,400,11,69,179,157,230));
    keyList.add(new myKey(560,400,670,650,12,93,173,226,240));
    keyList.add(new myKey(670,150,780,400,13,84,153,199,250));
    keyList.add(new myKey(670,400,780,650,14,165,105,189,260));
    keyList.add(new myKey(780,150,890,400,15,203,67,53,270));
    keyList.add(new myKey(780,400,890,650,16,100,30,22,280));
   */
   
   keyList.add(new myKey(0,100,450,410,1,0,255,0,150));
   keyList.add(new myKey(450,100,900,410,2,255,0,0,200));
   keyList.add(new myKey(0,410,450,720,3,255,255,0,250));
   keyList.add(new myKey(450,410,900,720,4,0,0,255,300));
  }

  void displayKeyList(){
    for( myKey k : keyList){
      k.display(false);
    }
  }
  
  int checkKeys(int x, int y){
    for(myKey k : keyList){
      if(k.isInside(x,y)){
        return k.getCount();
      }
    }
    return -1;
  }
  
  void generateNext(){
    int r;
    if(currentSounds > 0){
       r = levelList[currentSounds-1];
       while (r == levelList[currentSounds-1]){
         r = (int) random(1,16);
       }
    } else {
      levelList = new int[nSounds];
      r = (int) random(1,16);
    }
    
    for( myKey k : keyList){
      if(k.getCount() == r){
        levelList[currentSounds] = r;
        currentSounds++;
        currentKey = k;
        showKey();
        break;
      }   
    }
  }
  
  
  void showKey(){
    currentKey.display(true);
    displaySound = true;
  }
  
  void checkSound(int count){
    if(count != -1){
      userKeyPress = true;  
      pressedKey = count;
      for(myKey k : keyList){
        if(k.getCount() == count){
          currentKey = k;
          break;
        }
      }
      showKey();
    } 
  }
  
  String getGameName(){
    return gameName;
  }
  
  
  boolean isGameFinished(){
    return true;
  }
  
  
  void control(int keyPress){
    if(keyPress == ENTER){
      millis = millis();
      start = true;
    }
  }
  
  
  void control(int x, int y, boolean left){
    if(!isGameLoose && timerFinished){
      checkSound(checkKeys(x, y));
    }
  }

}

class myKey{

  int x, y, finx, finy, count, R, G, B, freq;
  
  myKey(int x, int y, int finx, int finy, int count, int R, int G, int B, int freq){
    this.x = x;
    this.y = y;
    this.finx = finx;
    this.finy = finy;
    this.count = count;
    this.R = R;
    this.G = G;
    this.B = B;
    this.freq = freq;
  }

  boolean isInside(int x, int y){
    if(x > this.x && x < this.finx && y > this.y && y < this.finy){
      return true;
    }
    return false;
  }
  
  void display(boolean b){
    if(b){
      fill(R,G,B, 250);
    } else {
      fill(R,G,B, 80);
    }
    rect(x,y, finx - x,finy - y);

  }
  
  int getX(){
    return x;
  }
  
  int getY(){
    return y;
  }
  
  int getfinX(){
    return finx;
  }
  
  int getfinY(){
    return finy;
  }
  
  int getCount(){
    return count;
  }
  
  int getFreq(){
    return freq;
  }
  
}
