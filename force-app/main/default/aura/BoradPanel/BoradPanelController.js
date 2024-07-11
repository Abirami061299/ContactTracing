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
        }
        else{
            component.set('v.reshuffleDisable',false);

        }
    }
})
