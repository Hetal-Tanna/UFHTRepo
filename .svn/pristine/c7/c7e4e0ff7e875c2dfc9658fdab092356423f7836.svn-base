public class TestProgressBar {
    public boolean enablePollar {get; set;}
    public integer progressCounter {get; set;}
    public TestProgressBar () {
        progressCounter = 20;
    }
    
    public PageReference incrementCounter(){
        if(progressCounter == 100){
           enablePollar = false;
        }
        else {   
            progressCounter += 10;
        }
        return null;
    }
    
    public PageReference save(){
        enablePollar = true;
        return null;
    }
}