class Memory extends MiniGame{
  
  
  ArrayList<myKey> keyList;
  
  Memory(String gameName){
    this.gameName = gameName;
    createKeyList();
  }
  
  void display(){
    if(start){
      if (timerFinished){
        inGame();
      } else {
        countDown();
      }
    } else {
      howToPlay();
    }
  }
  
  
  void howToPlay(){
    fill(0);
    textSize(50);
    text("PRESIONA ENTER PARA COMENZAR",15,300);
  }
  
  void inGame(){
    print("InGame");
    displayKeyList();
  }
  
  
  void createKeyList(){
    keyList = new ArrayList<myKey>();
    //Dejando 10 a izq y der, cada pieza es 110 de ancho.
    keyList.add(new myKey(10,150,120,400,1,0,0,0));
    keyList.add(new myKey(10,400,120,650,2,23,32,42));
    keyList.add(new myKey(120,150,230,400,3,33,47,60));
    keyList.add(new myKey(120,400,230,650,4,66,73,73));
    keyList.add(new myKey(230,150,340,400,5,123,125,125));
    keyList.add(new myKey(230,400,340,650,6,220,118,51));
    keyList.add(new myKey(340,150,450,400,7,235,152,78));
    keyList.add(new myKey(340,400,450,650,8,244,208,63));
    keyList.add(new myKey(450,150,560,400,9,88,214,141));
    keyList.add(new myKey(450,400,560,650,10,82,190,128));
    keyList.add(new myKey(560,150,670,400,11,69,179,157));
    keyList.add(new myKey(560,400,670,650,12,93,173,226));
    keyList.add(new myKey(670,150,780,400,13,84,153,199));
    keyList.add(new myKey(670,400,780,650,14,165,105,189));
    keyList.add(new myKey(780,150,890,400,15,203,67,53));
    keyList.add(new myKey(780,400,890,650,16,100,30,22));
  }

  void displayKeyList(){
    for( myKey k : keyList){
      k.display(false);
    }
  }
  
  int getScore(){
    return score;
  }
  
  
  String getGameName(){
    return gameName;
  }
  
  
  void control(int keyPress){
    if(keyPress == ENTER){
      millis = millis();
      start = true;
    }
  }
  
  
  void control(int x, int y, boolean left){
  
  }

}

class myKey{

  int x, y, finx, finy, count, R, G, B;
  
  myKey(int x, int y, int finx, int finy, int count, int R, int G, int B){
    this.x = x;
    this.y = y;
    this.finx = finx;
    this.finy = finy;
    this.count = count;
    this.R = R;
    this.G = G;
    this.B = B;
  }

  boolean isInside(int x, int y){
    if(x > this.x && x < this.finx && y > this.y && y < this.finy){
      return true;
    }
    return false;
  }
  
  void display(boolean b){
    if(b){
      fill(255);
    } else {
      fill(R,G,B);
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
  
}
