using UnityEngine;
using UnityEngine.UI;

public class ApplyZoom : MonoBehaviour
{
	public Camera cameraComponent;
	public Slider zoomSlider;
	public float zoomSpeed = 9f;
	
	public bool usesFOV = false;
	public Vector2 localZRange;


	public void Update ( )
	{
		var smoothing = (Time.smoothDeltaTime * Time.smoothDeltaTime) * zoomSpeed;

		if ( usesFOV )
		{
			var adjustedFov = zoomSlider.value;

			cameraComponent.fieldOfView = Mathf.
				Lerp ( cameraComponent.fieldOfView , adjustedFov , smoothing );

			cameraComponent.fieldOfView = Mathf.
				MoveTowards ( cameraComponent.fieldOfView, adjustedFov, smoothing);
		}
		else
		{
			var adjustedLocalPosition = Vector3.zero;

			adjustedLocalPosition.y = zoomSlider.value;
			adjustedLocalPosition.z = -zoomSlider.value;

			transform.localPosition = Vector3.
				Lerp ( transform.localPosition, adjustedLocalPosition, smoothing);

			transform.localPosition = Vector3.
				MoveTowards ( transform.localPosition, adjustedLocalPosition, smoothing );
		}
	}
}
