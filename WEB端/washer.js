//读取图片内容
var num = 0
function getSrcInner(id){

    var pic = document.getElementById(`${id}`)

    var picSrc = pic.getAttribute('src')

    var len = picSrc.length
    var loc = picSrc.lastIndexOf('/')

    // var header = picSrc.substring(0,loc+1)
    var tail = picSrc.substring(loc+1,len-4)

    // num = tail
    return tail
    // tail = src

    // pic.src = `${header}${tail}`
}

//改变图片内容
function changeSrcInner(id,value){
    var pic = document.getElementById(`${id}`)
    var picSrc = pic.getAttribute('src')

    // var len = picSrc.length
    var loc = picSrc.lastIndexOf('/')

    var header = picSrc.substring(0,loc+1)
    // var tail = picSrc.substring(loc+1,len-4)

    pic.src = `${header}${value}.png`
}

//时间加减函数
function timeUp(){

    var num1 = getSrcInner('seg1')
    var num2 = getSrcInner('seg2')

    num2++
    if(num2 == 10){
        num2 = 0
        num1++
    }
    if(num1 == 10){
        num1 = 0
    }

    if(isStart == true || isStop == true){
        if(isStart == false && isStop == true){
            fullNumber = num1 + num2
            console.log(fullNumber);
        }
        ps5.style.width = `${(num1*10+num2)/fullNumber*100}%`
    }
    
    changeSrcInner('seg2',num2)
    changeSrcInner('seg1',num1)
}
// setInterval(timeUp,500)

//结束音
var isEnd = false
function endSound(){
    setInterval(() => {
        if(isEnd == true){
            sound.play()
            console.log('play');
        }
    }, 200);
}


//时间减少函数
function timeDown() {
    var num1 = getSrcInner('seg1')
    var num2 = getSrcInner('seg2')

    if(num1 == 0 && num2 == 0 && isStart == true){
        endSound()

        ps1.style.width = '0%'
        ps2.style.width = '0%'
        ps3.style.width = '0%'
        ps4.style.width = '0%'
        ps5.style.width = `0%`
        state.innerHTML = '未启动'
        btnStart.innerHTML = 'START'
        explain.innerHTML = '洗涤结束，按启动按钮再次开始洗涤'
        isEnd = true
        setTimeout(() => {
            isEnd = false
            num1 = 3
            num2 = 0
            changeSrcInner('seg2',num2)
            changeSrcInner('seg1',num1)
            
            btnStart.disabled = false
            btnTimeUp.disabled = false
            btnTimeDown.disabled = false
            btnStop.disabled = true

            
        }, 1200);

        isStart = false
        isStop = false
        console.log('结束');

        isActionFinished = false
        
        changeSrcInner('forward','unchanged_forward')
        changeSrcInner('reverse','unchanged_reverse')
        changeSrcInner('pause','unchanged_pause')
        
    }else{
       num2-- 
    }

    if(num2 < 0){
        num2 = 9
        num1--
    }

    if(num1 < 0){
        num1 = 9
    }
    if(isStart == true || isStop == true){
        ps5.style.width = `${(num1*10+num2)/fullNumber*100}%`
    }
    changeSrcInner('seg2',num2)
    changeSrcInner('seg1',num1)
}
// setInterval(timeDown,500)

var ps1 = document.getElementById('ps1')
var ps2 = document.getElementById('ps2')
var ps3 = document.getElementById('ps3')
var ps4 = document.getElementById('ps4')
var ps5 = document.getElementById('ps5')

//计时函数
var count = 0
function counter(){
    count++
    // console.log(count);
    if(count == 12){
        count = 0
        ps1.style.width = '0%'
        ps2.style.width = '0%'
        ps3.style.width = '0%'
        ps4.style.width = '0%'
    }
    if(count < 4){
        // console.log(`${(count+1)*8.75}%`);
        ps1.style.width = `${(count+1)*8.75}%`
        changeSrcInner('forward','change_to_forward')
        changeSrcInner('reverse','unchanged_reverse')
        changeSrcInner('pause','unchanged_pause')
    }
    if(count >= 4 && count < 6){
        ps2.style.width = `${(count-3)*7.5}%`
        changeSrcInner('forward','unchanged_forward')
        changeSrcInner('reverse','unchanged_reverse')
        changeSrcInner('pause','change_to_pause')
        
    }
    if(count >= 6 && count < 10){
        ps3.style.width = `${(count-5)*8.75}%`
        changeSrcInner('forward','unchanged_forward')
        changeSrcInner('reverse','change_to_reverse')
        changeSrcInner('pause','unchanged_pause')

    }
    if(count >= 10 && count < 12){
        ps4.style.width = `${(count-9)*7.5}%`
        changeSrcInner('forward','unchanged_forward')
        changeSrcInner('reverse','unchanged_reverse')
        changeSrcInner('pause','change_to_pause')
    }
    console.log(count);
}
// setInterval(counter,1000)
// setInterval('console.log(count)',100)

var i = 0
function changeBytime(){
    i++
    if(i == 10){
        i = 0
    }
    
    console.log(i);
    var namea = `change_to_${i}.png`
    changeSrc(namea)
}
//全局数字get

var numSeg1 = getSrcInner('seg1')
var numSeg2 = getSrcInner('seg2')
var temp = 3
//开始动画
function startAction(){
    var num = 3
    btnStop.disabled = true
    setInterval(() => {
        if(isActionFinished == false && isStart == true){
            console.log('已知晓');
            
            num = temp
            changeSrcInner('forward','change_to_forward')
            changeSrcInner('reverse','change_to_reverse')
            changeSrcInner('pause','change_to_pause')

            sound.play()
            console.log(num);
            changeSrcInner('seg2',num)
            changeSrcInner('seg1',num)
            
            setTimeout(() => {
                changeSrcInner('seg2','unchanged_zero')
                changeSrcInner('seg1','unchanged_zero')
                changeSrcInner('forward','unchanged_forward')
                changeSrcInner('reverse','unchanged_reverse')
                changeSrcInner('pause','unchanged_pause')
                num--
                if(num == 0){
                    isActionFinished = true
                    btnStop.disabled = false
                    btnStart.innerText = 'Washing...'
                    state.innerHTML = '运行中'
                    explain.innerHTML = '启动成功，洗涤中......'
                    ps5.style.width = '100%'
                    changeSrcInner('seg2',numSeg2)
                    changeSrcInner('seg1',numSeg1)
                    fullNumber = numSeg1+numSeg2
                    console.log(fullNumber);
                }
                temp = num
                // console.log(num);
            }, 1000);
            
        }
    }, 1100);
    
    
}



//开始按键
var state = document.getElementById('state')
var sound = document.getElementById('sound')//蜂鸣器
var btnStart = document.getElementById('btnStart')
var isStart = false
var isDoing = false
var isActionFinished = false
var explain = document.getElementById('explain')
var fullNumber = 30
btnStart.onclick = function() {
    // alreadyStart = true
    // if (alreadyStart == true) {
        
    // }
    if(isStart == false){ //第一次按下 开启运行状态
        state.innerHTML = '启动中'
        explain.innerHTML = '不可操作状态，3S后初始化完成'
        sound.play()
        changeSrcInner('start','change_to_start')
        setTimeout(() => {
            changeSrcInner('start','unchanged_start')
        }, 200);
        
        if(isStop == false){
            temp = 3
            numSeg1 = getSrcInner('seg1')
            numSeg2 = getSrcInner('seg2')
            isActionFinished = false
            btnStop.disabled = true
            console.log('可以启动');
            console.log('启动完成');
        }
        
        isStart = true
        
        btnStart.disabled = true
        btnTimeUp.disabled = true
        btnTimeDown.disabled = true
        // btnStop.disabled = false    //运行中只能按下停止按键

        if(isStop == true){
            btnStart.innerText = 'Washing...'
            btnStop.innerText = 'STOP'
            isStop = false
            state.innerHTML = '运行中'
            explain.innerHTML = '洗涤继续进行'
        }

    }
    if(isStop == true){
        isStop = false
    }


    if(isDoing == false){
        isDoing = true
        temp = 3
        numSeg1 = getSrcInner('seg1')
        numSeg2 = getSrcInner('seg2')
        startAction()
        setInterval(() => {
        if (isStop == false && isStart == true && isActionFinished == true) {
            counter()
            if (count == 0) {
                timeDown()
                numSeg1 = getSrcInner('seg1')
                numSeg2 = getSrcInner('seg2')
                if(numSeg1 == 0 && numSeg2 == 0){
                    timeDown()
                }
            }
        }
    }, 500);
    }
    
}

//停止按键
var btnStop = document.getElementById('btnStop')
var isStop = false
btnStop.disabled = true
btnStop.onclick = function() {

    if (isStop == false) { //第一次按下 洗涤状态中按下 进入中断
        isStop = true       //中断态为真
        isStart = false     

        btnStart.disabled = false      //中断状态下按钮都可按下
        btnTimeUp.disabled = false
        btnTimeDown.disabled = false

        btnStart.innerText = 'Continue'     //中断状态下改变按钮显示值
        btnStop.innerText = 'EXIT'

        state.innerHTML = '暂停'
        explain.innerHTML = '暂停中，可修改洗涤计时'

    }else{          //进入结束状态
        console.log('结束');
        changeSrcInner('seg2',0)
        changeSrcInner('seg1',3)

        btnStart.innerText = 'START'
        btnStop.innerText = 'STOP'
        btnStop.disabled = true

        count = 0

        isStop = false
        isStart = false

        ps1.style.width = '0%'
        ps2.style.width = '0%'
        ps3.style.width = '0%'
        ps4.style.width = '0%'
        ps5.style.width = '0%'
        state.innerHTML = '未启动'
        explain.innerHTML = '结束洗涤，按启动按钮再次开启洗涤'
    }

    sound.play()
    changeSrcInner('stop','change_to_stop')
    setTimeout(() => {
        changeSrcInner('stop','unchanged_stop')
    }, 200);
    
}

//计时增减按键
var btnTimeUp = document.getElementById('btnTimeUp')
btnTimeUp.onclick = function() {
    sound.play()
    timeUp()
    
    // setTimeout(changeSrcInner('timeUp','change_to_time+'),12000)
    // console.log(getSrcInner('timeUp'));
    changeSrcInner('timeUp','change_to_time+')
    setTimeout(() => {
        changeSrcInner('timeUp','unchanged_time+')
    }, 200);

    // changeSrcInner('timeUp','unchanged_time+')
    // setTimeout(changeSrcInner('timeUp','unchanged_time+',9000))
    // console.log(getSrcInner('timeUp'));
}
//计时减少按键
var btnTimeDown = document.getElementById('btnTimeDown')
btnTimeDown.onclick = function() {
    sound.play()
    timeDown()
    changeSrcInner('timeDown','change_to_time-')
    setTimeout(() => {
        changeSrcInner('timeDown','unchanged_time-')
    }, 200);
}
