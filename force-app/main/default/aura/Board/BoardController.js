({
    doInit: function (component, event, helper) {
        console.log("Initialiation completed");
        const gameMode=component.get("v.mode");
        let column=0;
        if(gameMode && gameMode==='hard'){
            column=6;
        }
        else if(gameMode==='medium'){
            column=4;
        }
        else {
            column=3;
        }
        let blockSize=12/column;
        component.set("v.blockSize",blockSize);
        // build a list of 100 words
        const words = helper.getWords(column * column);
        component.set("v.words", words);
        console.log("Words: " + words);
        // get win word
        const winWord = helper.getWinWord(words);
        component.set("v.winWord", winWord);
        console.log("Win word: " + helper.getWinWord(words));
        helper.resetBoard(component)
    },

    doRender: function (component, event, helper) {
        console.log("Render completed");
    },
    blockClickHandler:function(component, event, helper){
        let clickCount=component.get("v.clickCount") + 1;
        const value=event.getParam('value');
        if(value==component.get("v.winWord")){
            component.set("v.result", 'YOU WON');
            console.log('YOU WON');
            helper.disableBoard(component);
            helper.fireResultEvent('WIN');
        }
        else if(clickCount === 3){
            component.set("v.result", "YOU LOST");
            console.log('YOU LOST');
            helper.disableBoard(component);
            helper.fireResultEvent('LOSE');

        }
        component.set("v.clickCount", clickCount);

    },
    reshuffleBoard:function(component, event, helper){
        const words=component.get('v.words');
        const randomized=helper.randomizeArray(words);
        component.set('v.words',randomized);
        helper.resetBoard();
    }
});
