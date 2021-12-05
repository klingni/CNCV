// Countdown

const FULL_DASH_ARRAY = 283;
const WARNING_THRESHOLD = 10;
const ALERT_THRESHOLD = 5;

const COLOR_CODES = {
  info: {
    color: "green"
  },
  warning: {
    color: "orange",
    threshold: WARNING_THRESHOLD
  },
  alert: {
    color: "red",
    threshold: ALERT_THRESHOLD
  }
};

let TIME_LIMIT = 20;
let timePassed = 0;
let timeLeft = TIME_LIMIT;
let timerInterval = null;
let remainingPathColor = COLOR_CODES.info.color;

$(function () {
    window.addEventListener('message', function (event) {

        var item = event.data;
        var buf = $('#scoreboard');

        if (item.scoreboard && item.scoreboard.show == false) {
            document.getElementById("cop_data").innerHTML = "";
            document.getElementById("crook_data").innerHTML = "";
            document.getElementById("lobby_data").innerHTML = "";
            document.getElementById("cop_score").innerHTML = "";
            document.getElementById("crook_score").innerHTML = "";
            $('#scoreboard').hide();
            return;

        } else if (item.scoreboard && item.scoreboard.show == true){
            var Score = item["Score"];
            var PlayerInfos = item["PlayerInfos"];

            
    
            document.getElementById("cop_score").innerHTML = Score['cop'];
            document.getElementById("crook_score").innerHTML = Score['crook'];
    
    
            for (let i = 0; i < PlayerInfos.length; i++) {
                const element = PlayerInfos[i];
    
                switch (element['team']) {
                    case 'cop':
                        buf.find('#cop_data').append("<tr><td colspan='2'>" + element["playerName"] + "</td></tr>");
                        break;
    
                    case 'crook':
                        if (element["isBoss"] == true) {
                            buf.find('#crook_data').append("<tr><td colspan='2'>👑 " + element["playerName"] + "</td></tr>");
    
                        } else {
    
                            buf.find('#crook_data').append("<tr><td colspan='2'>" + element["playerName"] + "</td></tr>");
                        }
                        break;
    
                    case 'lobby':
                        buf.find('#lobby_data').append("<tr><td colspan='2'>" + element["playerName"] + "</td></tr>");
                        break;
    
                    default:
                        break;
                }
            }
            $('#scoreboard').show();
            
        } else if(item.countdown && item.countdown.show == true){
            timeLeft = item.countdown.time;
            TIME_LIMIT = item.countdown.time;
            remainingPathColor = COLOR_CODES.info.color;

            document.getElementById("base-timer-label").innerHTML = formatTime(timeLeft);
            document.getElementById("info-text").innerHTML = item.countdown.text;
            document.getElementById("base-timer-path-remaining").classList.remove(COLOR_CODES.alert.color);
            document.getElementById("base-timer-path-remaining").classList.remove(COLOR_CODES.warning.color);
            document.getElementById("base-timer-path-remaining").classList.add(remainingPathColor);
            startTimer();
            $('#countdown').show();

        } else if(item.countdown && item.countdown.show == false){
            $('#countdown').hide();
            onTimesUp();
        }

        


    }, false);


});




function onTimesUp() {
    clearInterval(timerInterval);
    timePassed = 0;
  }
  
  function startTimer() {
    timerInterval = setInterval(() => {
      timePassed = timePassed += 1;
      timeLeft = TIME_LIMIT - timePassed;
      document.getElementById("base-timer-label").innerHTML = formatTime(
        timeLeft
      );
      setCircleDasharray();
      setRemainingPathColor(timeLeft);
  
      if (timeLeft === 0) {
        onTimesUp();
      }
    }, 1000);
  }
  
  function formatTime(time) {
    const minutes = Math.floor(time / 60);
    let seconds = time % 60;
  
    if (seconds < 10) {
      seconds = `0${seconds}`;
    }
  
    return `${minutes}:${seconds}`;
  }
  
  function setRemainingPathColor(timeLeft) {
    const { alert, warning, info } = COLOR_CODES;
    if (timeLeft <= alert.threshold) {
      document
        .getElementById("base-timer-path-remaining")
        .classList.remove(warning.color);
      document
        .getElementById("base-timer-path-remaining")
        .classList.add(alert.color);
    } else if (timeLeft <= warning.threshold) {
      document
        .getElementById("base-timer-path-remaining")
        .classList.remove(info.color);
      document
        .getElementById("base-timer-path-remaining")
        .classList.add(warning.color);
    }
  }
  
  function calculateTimeFraction() {
    const rawTimeFraction = timeLeft / TIME_LIMIT;
    return rawTimeFraction - (1 / TIME_LIMIT) * (1 - rawTimeFraction);
  }
  
  function setCircleDasharray() {
    const circleDasharray = `${(
      calculateTimeFraction() * FULL_DASH_ARRAY
    ).toFixed(0)} 283`;
    document
      .getElementById("base-timer-path-remaining")
      .setAttribute("stroke-dasharray", circleDasharray);
  }