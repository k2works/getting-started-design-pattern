// Observer パターン
// trait と mutable リストでイベント通知を実現する

package designpattern.observer

import scala.collection.mutable.ListBuffer

trait Observer:
  def update(employee: Employee): Unit

class Employee(val name: String, private var _salary: Double):
  private val observers: ListBuffer[Observer] = ListBuffer.empty

  def salary: Double = _salary

  def salary_=(newSalary: Double): Unit =
    _salary = newSalary
    notifyObservers()

  def addObserver(observer: Observer): Unit =
    observers += observer

  def removeObserver(observer: Observer): Unit =
    observers -= observer

  def notifyObservers(): Unit =
    observers.foreach(_.update(this))

class Payroll extends Observer:
  var lastEmployee: Option[Employee] = None

  override def update(employee: Employee): Unit =
    lastEmployee = Some(employee)
    // 給与計算のために記録

class TaxMan extends Observer:
  var lastEmployee: Option[Employee] = None

  override def update(employee: Employee): Unit =
    lastEmployee = Some(employee)
    // 税金計算のために記録
