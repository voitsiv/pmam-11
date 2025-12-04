using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

public class SensorData
{
    public string SensorName { get; }
    public double Value { get; }
    public DateTime Timestamp { get; }

    public SensorData(string name, double value, DateTime time)
    {
        SensorName = name;
        Value = value;
        Timestamp = time;
    }
}

public delegate void CriticalAlertHandler(string message);

public class Sensor
{
    public string Name { get; }
    private readonly Random _random = new Random();
    
    public event CriticalAlertHandler OnCriticalValue;

    public Sensor(string name)
    {
        Name = name;
    }

    public async Task StartMonitoringAsync(List<SensorData> database, CancellationToken token)
    {
        Console.WriteLine($"[SYSTEM] Сенсор {Name} активовано.");

        while (!token.IsCancellationRequested)
        {
            try
            {
                await Task.Delay(_random.Next(500, 1500), token);

                double value = Math.Round(20 + (_random.NextDouble() * 15), 1);
                
                lock (database) 
                {
                    database.Add(new SensorData(Name, value, DateTime.Now));
                }

                if (value > 33.0)
                {
                    OnCriticalValue?.Invoke($"УВАГА! {Name} зафіксував високий рівень: {value}");
                }
                else
                {
                    Console.WriteLine($"   -> {Name}: {value}");
                }
            }
            catch (TaskCanceledException)
            {
                break;
            }
        }
        Console.WriteLine($"[SYSTEM] Сенсор {Name} вимкнено.");
    }
}

public class Program
{
    static List<SensorData> _sensorHistory = new List<SensorData>();

    public static async Task Main(string[] args)
    {
        Console.WriteLine("--- SMART HOME ---");
        Console.WriteLine("Запуск симуляції на 5 секунд...\n");

        var cts = new CancellationTokenSource();
        
        var tempSensor = new Sensor("Termo-X1");
        var humiditySensor = new Sensor("Humidity-Z5");

        tempSensor.OnCriticalValue += (msg) => Console.WriteLine(msg);

        var task1 = tempSensor.StartMonitoringAsync(_sensorHistory, cts.Token);
        var task2 = humiditySensor.StartMonitoringAsync(_sensorHistory, cts.Token);

        await Task.Delay(5000);
        
        Console.WriteLine("\n[SYSTEM] Зупинка системи...");
        cts.Cancel();

        try 
        {
            await Task.WhenAll(task1, task2);
        }
        catch (TaskCanceledException) { } 

        ShowStatistics();
    }

    static void ShowStatistics()
    {
        Console.WriteLine("\n--- АНАЛІТИКА ДАНИХ (LINQ) ---");

        if (!_sensorHistory.Any())
        {
            Console.WriteLine("Даних немає.");
            return;
        }

        var report = _sensorHistory
            .GroupBy(d => d.SensorName)
            .Select(g => new 
            {
                Sensor = g.Key,
                AvgValue = g.Average(x => x.Value),
                MaxValue = g.Max(x => x.Value),
                Count = g.Count()
            });

        foreach (var item in report)
        {
            Console.WriteLine($"Сенсор: {item.Sensor} | Записів: {item.Count} | Середнє: {item.AvgValue:F2} | Макс: {item.MaxValue}");
        }
    }
}
