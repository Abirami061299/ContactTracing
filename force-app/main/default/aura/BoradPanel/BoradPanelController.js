({
    startGame : function(component, event, helper) {
        let comboBox=component.find("gameMode");
        let selectedValue=comboBox.get("v.value");
        component.set("v.selectedMode",selectedValue);
        let selectedMode=component.get('v.selectedMode');;
        if(selectedMode){
            const boardComp=component.find('boardComp');
            boardComp.startGame();
            component.set('v.reshuffleDisable',true);

        }
    },
    reshuffleBoard : function(component, event, helper) {
        const boardComp=component.find('boardComp');
        boardComp.reshuffleBoard();
    },
    onResultHandler:function(component, event, helper) {
        const result=event.getParam('result');
        if(result=='win'){
            component.set('v.reshuffleDisable',true);
            helper.showToast('YOU WIN','HOORAY!','success');
        }
        else{
            component.set('v.reshuffleDisable',false);
            helper.showToast('YOU LOSE','Reshuffle the board to keep playing!','error');

        }
        helper.addResult(component,result);

    }
})
