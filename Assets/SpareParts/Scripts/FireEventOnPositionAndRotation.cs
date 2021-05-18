using UnityEngine;

public class FireEventOnPositionAndRotation : MonoBehaviour
{
	public Transform referenceOverride;
	public Space coordinatesSpace;
	public CoordinatesEvent triggeredEvents;


	private Transform coordinatesReference;
	private Vector3 eventPosition;
	private Quaternion eventRotation;

	public void FireEvents ( ) 
	{
		coordinatesReference = referenceOverride ? referenceOverride : transform;

		eventPosition = coordinatesSpace
			== Space.Self ? 
			coordinatesReference.localPosition 
			: coordinatesReference.position;

		eventRotation = coordinatesSpace
			== Space.Self ? 
			coordinatesReference.localRotation 
			: coordinatesReference.rotation;

		triggeredEvents.Invoke ( coordinatesReference, eventPosition, eventRotation );
	}
}
