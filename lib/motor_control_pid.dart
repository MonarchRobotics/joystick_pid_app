class MotorControlPID {
  double target;
  double Kp;
  double Ki;
  double Kd;
  double sumE;
  double previousE;
  double maxValue;
  double ceiling;


  MotorControlPID(double target, double maxValue, double ceiling, double Kp, double Ki, double Kd){
    this.target = target;
    this.maxValue = maxValue;
    this.ceiling = ceiling;
    this.Kp = Kp;
    this.Ki = Ki;
    this.Kd = Kd;
    sumE = 0;
    previousE = 0;
  }

   double getSpeed(double current){
    //do some calculations to determine how fast the motor will go.
    //let e = vt -vc;
    //vs = (Kp * e) + (Ki * sum(e)) + (Kd*delta(e));

    double e = (target - current);
    double deltaE = previousE - e;
    sumE += e;
    double speed = Kp * e + Ki * sumE + Kd * deltaE;
//    print(sumE);
    previousE = e;
    double adjustedSpeed = speed * maxValue;
    if(adjustedSpeed>0 && adjustedSpeed>ceiling){
      adjustedSpeed = ceiling;
    }
    else if(adjustedSpeed<0 && adjustedSpeed<-ceiling){
      adjustedSpeed = -ceiling;
    }
    return adjustedSpeed;
  }


   void reset(){
    previousE = 0;
    sumE = 0;
  }

   double getPreviousE() {
    return previousE;
  }

   void setTarget(double target) {
    this.target = target;
  }

   double getTarget() {
    return target;
  }

   void setKd(double kd) {
    Kd = kd;
  }

   void setKi(double ki) {
    Ki = ki;
  }

   void setKp(double kp) {
    Kp = kp;
  }

   double getKd() {
    return Kd;
  }

   double getKi() {
    return Ki;
  }

   double getKp() {
    return Kp;
  }

   void incrementCeiling(double add){
    ceiling+=add;
  }

   double getCeiling() {
    return ceiling;
  }
}
