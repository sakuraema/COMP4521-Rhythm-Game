using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class FireEventOnKeyDown : MonoBehaviour
{
	public KeyCode triggeringKey;
	public UnityEvent triggeredEvent;

	private void Update ( )
	{
		if ( Input.GetKeyDown ( triggeringKey ) )
			triggeredEvent.Invoke ( );
	}
}
