using System.Collections.Generic;
using UnityEngine;
using Core.Utilities;

public class Scroller : Singleton<Scroller>
{
	public float BPM;
	public int speed;
	public float spawnDelay;
	public Vector3[] spawnPoint;
	public Poolable barPoolable;
	public Transform startingLine;
	public Transform endingLine;

	private RepeatingTimer m_SpawnBarTimer;
	private Timer m_SpawnDelayTimer;
	private List<Bar> m_ActiveBars = new List<Bar>();
	private Vector3 m_Velocity;
	private float m_TrackLength;
	private float m_Delay;

	void SpawnBar()
	{
		var spawningBar = PoolManager.instance.GetPoolable(barPoolable).GetComponent<Bar>();
		spawningBar.gameObject.SetActive(true);
		spawningBar.transform.position = spawnPoint[Random.Range(0, spawnPoint.Length)];
		m_ActiveBars.Add(spawningBar);
	}
	
	void StartSpawning()
	{
		m_SpawnDelayTimer = null;
		m_SpawnBarTimer = new RepeatingTimer(1f / (BPM / 60.0f), SpawnBar);
		Debug.Log("Start spawning at " + Time.time);
	}

	protected override void Awake()
    {
		m_TrackLength = startingLine.position.z - endingLine.position.z;
		m_Velocity = new Vector3(0, 0, -speed); // 100
		for (int i = 0; i < spawnPoint.Length; i++)
		{
			spawnPoint[i].z = m_TrackLength;
		}
		m_Delay = spawnDelay - m_TrackLength / speed;
		m_SpawnDelayTimer = new Timer(m_Delay, StartSpawning);
		//transform.position = new Vector3 (0.0f, 0.0f, 300.0f * (BPM / 60.0f) * (50.0f / 60.0f));
	}

	void FixedUpdate()
    {
		m_SpawnDelayTimer?.Tick(Time.fixedDeltaTime);
		m_SpawnBarTimer?.Tick(Time.fixedDeltaTime);
		for (int i = m_ActiveBars.Count - 1; i >= 0; i--)
		{
			var bar = m_ActiveBars[i];
			bar.transform.position += m_Velocity * Time.fixedDeltaTime;
			
			if (bar.transform.position.z < -m_TrackLength)
			{
				bar.Reset();
				PoolManager.instance.ReturnPoolable(bar.GetComponent<Poolable>());
				m_ActiveBars.Remove(bar);
			}
		}
        //transform.position -= new Vector3(0.0f, 0.0f, BPM * Time.deltaTime * (50.0f / 60.0f));
    }
}
