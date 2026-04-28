namespace DesignPattern.Observer

/// Observer パターン
/// F# ではコールバック関数のリストや Event 型で表現する。
module Observer =

    /// オブザーバーはメッセージを受け取る関数
    type Observer<'T> = 'T -> unit

    /// Subject はオブザーバーのリストを保持し、通知を行う
    type Subject<'T>() =
        let mutable observers: Observer<'T> list = []

        member _.AddObserver(observer: Observer<'T>) = observers <- observer :: observers

        member _.RemoveObserver(observer: Observer<'T>) =
            observers <- observers |> List.filter (fun o -> not (obj.ReferenceEquals(o, observer)))

        member _.NotifyObservers(value: 'T) =
            observers |> List.iter (fun observer -> observer value)

        member _.ObserverCount = observers.Length

    /// 給与を管理する従業員
    type Employee = { Name: string; mutable Salary: float }

    /// 従業員の給与変更を監視する Subject
    type EmployeeSubject() =
        let subject = Subject<string>()

        member _.AddObserver(observer) = subject.AddObserver(observer)
        member _.RemoveObserver(observer) = subject.RemoveObserver(observer)
        member _.ObserverCount = subject.ObserverCount

        member _.UpdateSalary(employee: Employee, newSalary: float) =
            let oldSalary = employee.Salary
            employee.Salary <- newSalary

            let message =
                sprintf "%s の給与が %.0f から %.0f に変更されました" employee.Name oldSalary newSalary

            subject.NotifyObservers(message)
