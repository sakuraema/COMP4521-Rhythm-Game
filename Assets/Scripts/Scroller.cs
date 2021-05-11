using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.Utilities;

public class Scroller : Singleton<Scroller>
{
	static readonly private float BEAT_INTERVAL = 4f;

	public float bgm = 128;
	public float speedMultiplier = 1;

	private Vector3 m_Velocity;
	private float m_Speed;

	public float Speed { get => m_Speed; set => m_Speed = value; }

	protected override void Awake()
	{
		base.Awake();
		m_Speed = BEAT_INTERVAL * speedMultiplier / (60 / bgm);
		m_Velocity = new Vector3(0f, 0f, -m_Speed);

		// Scaling according to speed
		float scaleZ = speedMultiplier;
		transform.localScale = new Vector3(1, 1, scaleZ);
		foreach (Transform child in transform)
		{
			if (child.GetComponent<LongNote>() != null)
			{
				child.localScale = new Vector3(child.localScale.x, child.localScale.y, child.localScale.z / scaleZ * speedMultiplier);
			}
			else
			{
				child.localScale = new Vector3(child.localScale.x, child.localScale.y, child.localScale.z / scaleZ);
			}
		}
	}

	private void Update()
	{
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
