var w = window.innerWidth,
  h = window.innerHeight,
  container = document.getElementById("snow"),
  sizes = ["Small", "Medium", "Large"],
  types = ["round", "star", "real", "sharp", "ring"],
  snowflakes = 25;

for (var i = 0; i < snowflakes; i++) {
  var snowflakeDiv = document.createElement("div");
  var sizeIndex = Math.ceil(Math.random() * 3) - 1; //get random number between 0 and 2
  var size = sizes[sizeIndex]; //get random size
  var typeIndex = Math.ceil(Math.random() * 5) - 1;
  var type = types[typeIndex];
  TweenMax.set(snowflakeDiv, {
    attr: { class: type + size },
    x: R(0, w),
    y: R(-200, -150),
  });
  container.appendChild(snowflakeDiv);
  snowing(snowflakeDiv);
}

function snowing(element) {
  TweenMax.to(element, R(5, 12), {
    y: h + 100,
    ease: Linear.easeNone,
    repeat: -1,
    delay: 7,
  });
  TweenMax.to(element, R(4, 8), {
    x: "+=100",
    repeat: -1,
    yoyo: true,
    ease: Sine.easeInOut,
  });
  TweenMax.to(element, R(2, 8), {
    rotation: R(0, 360),
    repeat: -1,
    yoyo: true,
    ease: Sine.easeInOut,
    delay: 50,
  });
}

function R(min, max) {
  return min + Math.random() * (max - min);
}

// Set the date we're counting down to
var countDownDate = new Date("Jan 2, 2020 10:00").getTime();

// Update the count down every 1 second
var x = setInterval(function () {
  // Get today's date and time
  var now = new Date().getTime();

  // Find the distance between now and the count down date
  var distance = countDownDate - now;

  // Time calculations for days, hours, minutes and seconds
  var days = Math.floor(distance / (1000 * 60 * 60 * 24));
  var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));

  var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
  var seconds = Math.floor((distance % (1000 * 60)) / 1000);

  // Output the result in an element with id="timer"
  document.getElementById("timer").innerHTML =
    days + "d " + hours + "h " + minutes + "m " + seconds + "s ";

  // If the count down is over, write some text
  if (distance < 0) {
    clearInterval(x);
    document.getElementById("timer").innerHTML = "They're married!!";
  }
}, 1000);
