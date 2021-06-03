class User{ 
  private final int ID;
  private String name;
  private int[] score = {-1, -1, -1};
  private String profileImage;
  
  public User(int ID, String name){
    this.ID = ID;
    this.name = name;
    this.profileImage = "";
  }
  
  public void setName(String name){
    this.name = name;
  }
  
  public void setProfileImage(String profileImage){
    this.profileImage = profileImage;
  }
  
  public void setScoreOf(int newScore, String game){
    switch(game){
      case "Sudoku":
        if(newScore < score[0] || score[0] == -1) score[0] = newScore;
        break;
      case "Coins":
        if(newScore < score[1] || score[1] == -1) score[1] = newScore;
        break;
      case "Memory":
        if(newScore > score[2] || score[2] == -1) score[2] = newScore;
        break;
      default:
        break;
    }
  }
  
  public String getName(){
    return name;
  }
  
  public String getProfileImage(){
    return profileImage;
  }
  
  public int getScoreOf(String game){
    int index = 0;
    switch(game){
      case "Sudoku":
        index = 0;
        break;
      case "Coins":
        index = 1;
        break;
      case "Memory":
        index = 2;
        break;
      default:
        break;
    }
    return score[index];
  }
  
  public int getID(){
    return ID;
  }
}
