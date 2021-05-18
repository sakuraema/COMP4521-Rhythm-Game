using UnityEngine;

public class Rotate : MonoBehaviour
{
	public Space space = Space.Self;
	public Vector3 speed = new  Vector3(0f, 3f, 0f);

	private float smoothing;
	private Vector3 currentUpdateSpeed;

	public void ApplyRotation () { ApplyRotation ( 1f,1f,1f,1f); }

	public void ApplyRotation ( 
		float timeScale = 0f, 
		float time=0f, 
		float deltatime = 0f, 
		float smoothDeltatime = 0f )
	{
		smoothing = smoothDeltatime == 0 
			? Time.smoothDeltaTime : smoothDeltatime;

		currentUpdateSpeed.x = speed.x * smoothing;
		currentUpdateSpeed.y = speed.y * smoothing;
		currentUpdateSpeed.z = speed.z * smoothing;

		transform.Rotate ( currentUpdateSpeed, space );
	}
}
