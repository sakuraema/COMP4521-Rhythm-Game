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
	private List<Beat> m_Beatmap;
	private int m_BeatCount = 0;

	public void ReturnBarToPool(Bar bar)
	{
		bar.Reset();
		PoolManager.instance.ReturnPoolable(bar.GetComponent<Poolable>());
		m_ActiveBars.Remove(bar);
	}

	protected void SpawnBar()
	{
		if (m_BeatCount >= m_Beatmap.Count)
		{
			m_SpawnBarTimer = null;
			return;
		}
		for (int i = 0; i < 4; i++)
		{
			if (m_Beatmap[m_BeatCount].tracks[i])
			{
				var bar = PoolManager.instance.GetPoolable(barPoolable).GetComponent<Bar>();
				bar.gameObject.SetActive(true);
				bar.transform.position = spawnPoint[i];
				m_ActiveBars.Add(bar);
			}
		}
		m_BeatCount++;
	}
	
	protected void StartSpawning()
	{
		m_SpawnDelayTimer = null;
		m_SpawnBarTimer = new RepeatingTimer(1f / (BPM / 60.0f), SpawnBar);
	}

	protected override void Awake()
    {
		base.Awake();
		m_TrackLength = startingLine.position.z - endingLine.position.z;
		m_Velocity = new Vector3(0, 0, -speed);
		for (int i = 0; i < spawnPoint.Length; i++)
		{
			spawnPoint[i].z = m_TrackLength;
		}
		m_Delay = spawnDelay - m_TrackLength / speed;
		m_SpawnDelayTimer = new Timer(m_Delay, StartSpawning);
		m_Beatmap = Beatmap.instance.beats;
	}

	protected virtual void FixedUpdate()
    {
		m_SpawnDelayTimer?.Tick(Time.fixedDeltaTime);
		m_SpawnBarTimer?.Tick(Time.fixedDeltaTime);
		for (int i = m_ActiveBars.Count - 1; i >= 0; i--)
		{
			var bar = m_ActiveBars[i];
			bar.transform.position += m_Velocity * Time.fixedDeltaTime;
			
			if (bar.transform.position.z < -m_TrackLength)
			{
				ReturnBarToPool(bar);
			}
		}
    }
}
