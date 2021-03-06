using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.Utilities;

public class Scroller : Singleton<Scroller>
{
	static readonly private float BEAT_INTERVAL = 4f;

	public float BPM;

	private Vector3 m_Velocity;
	private float m_Speed;
	private bool m_IsMusicEnded;

	public float Speed { get => m_Speed; set => m_Speed = value; }

	protected override void Awake()
	{
		base.Awake();
		//m_Speed = BEAT_INTERVAL * speedMultiplier / (60 / BPM);
		m_Speed = BEAT_INTERVAL * GameManager.instance.ScrollSpeed;
		m_Velocity = new Vector3(0f, 0f, -m_Speed);

		MusicPlayer.instance.onMusicEnd.AddListener(() => m_IsMusicEnded = true);

		// Scaling according to speed
		float scaleZ = GameManager.instance.ScrollSpeed * (60 / BPM);
		transform.localScale = new Vector3(1, 1, scaleZ);
		foreach (Transform child in transform)
		{
			if (child.GetComponent<SingleNote>() != null)
			{
				child.localScale = new Vector3(child.localScale.x, child.localScale.y, child.localScale.z / scaleZ);
			}
		}
	}

	private void Update()
	{
		if (m_IsMusicEnded) return;
		transform.position += m_Velocity * Time.deltaTime;
	}

	private void OnDrawGizmos()
	{
		Gizmos.color = Color.blue;
		Gizmos.DrawLine(new Vector3(-2, 0, 0), new Vector3(-2, 0, 2000));
		Gizmos.DrawLine(new Vector3(0, 0, 0), new Vector3(0, 0, 2000));
		Gizmos.DrawLine(new Vector3(2, 0, 0), new Vector3(2, 0, 2000));
		for (int i = 0; i < 1000; i++)
		{
			if (i % 4 == 0)
			{
				Gizmos.color = Color.red;
			}
			else
			{
				Gizmos.color = Color.white;
			}
			var from = new Vector3(-4, 0, 4f * i);
			var to = new Vector3(4, 0, 4f * i);
			Gizmos.DrawLine(from, to);
		}
	}
}
