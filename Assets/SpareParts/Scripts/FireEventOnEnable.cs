using UnityEngine;
using UnityEngine.Events;

public class FireEventOnEnable : MonoBehaviour
{
	public UnityEvent triggeredEvents;

	private void OnEnable ( )
		=> triggeredEvents.Invoke ( );
}
