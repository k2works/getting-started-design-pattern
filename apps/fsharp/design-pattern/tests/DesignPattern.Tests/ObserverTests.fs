module DesignPattern.Tests.ObserverTests

open Xunit
open DesignPattern.Observer.Observer

[<Fact>]
let ``Subject にオブザーバーを追加できる`` () =
    let subject = Subject<string>()
    subject.AddObserver(fun _ -> ())
    Assert.Equal(1, subject.ObserverCount)

[<Fact>]
let ``オブザーバーに通知が届く`` () =
    let subject = Subject<string>()
    let mutable received = ""
    subject.AddObserver(fun msg -> received <- msg)
    subject.NotifyObservers("テスト通知")
    Assert.Equal("テスト通知", received)

[<Fact>]
let ``複数のオブザーバーに通知が届く`` () =
    let subject = Subject<string>()
    let messages = System.Collections.Generic.List<string>()
    subject.AddObserver(fun msg -> messages.Add("A: " + msg))
    subject.AddObserver(fun msg -> messages.Add("B: " + msg))
    subject.NotifyObservers("テスト")
    Assert.Equal(2, messages.Count)

[<Fact>]
let ``従業員の給与変更を監視できる`` () =
    let employeeSubject = EmployeeSubject()
    let mutable notification = ""
    employeeSubject.AddObserver(fun msg -> notification <- msg)
    let emp = { Name = "田中"; Salary = 300000.0 }
    employeeSubject.UpdateSalary(emp, 350000.0)
    Assert.Contains("田中", notification)
    Assert.Contains("300000", notification)
    Assert.Contains("350000", notification)
    Assert.Equal(350000.0, emp.Salary)
