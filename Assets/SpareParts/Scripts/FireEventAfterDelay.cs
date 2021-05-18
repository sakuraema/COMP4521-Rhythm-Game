using System.Collections;
using UnityEngine;
using UnityEngine.Events;

public class FireEventAfterDelay : MonoBehaviour
{
	public float delay;
	public UnityEvent TriggeredEvents;
	private float scheduledTime;

	public void FireEvents ( )
	{
		scheduledTime = Time.time + delay;
		StopAllCoroutines ( );
		StartCoroutine ( WaitAndFire() );
	}

	private IEnumerator WaitAndFire ( )
	{
		while ( Time.time < scheduledTime ) yield return null;
		TriggeredEvents.Invoke ( );
	}
}
