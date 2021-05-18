using UnityEngine;
using System.Collections;

public class FlyCamera : MonoBehaviour
{
	public float mainSpeed = 100.0f; 
	public float shiftAdd = 250.0f; 
	public float maxShift = 1000.0f;
	public float camSens = 0.25f; 
	public bool rotateOnlyIfMousedown = true;
	public bool movementStaysFlat = true;

	private Vector3 lastMouse = new Vector3 ( 255, 255, 255 ); 
	private float totalRun = 1.0f;

	void Update ( )
	{

		if ( Input.GetMouseButtonDown ( 1 ) )
			lastMouse = Input.mousePosition; 

		if ( !rotateOnlyIfMousedown ||
			( rotateOnlyIfMousedown && Input.GetMouseButton ( 1 ) ) )
		{
			lastMouse = Input.mousePosition - lastMouse;
			lastMouse = new Vector3 ( -lastMouse.y * camSens, lastMouse.x * camSens, 0 );
			lastMouse = new Vector3 ( transform.eulerAngles.x + lastMouse.x, transform.eulerAngles.y + lastMouse.y, 0 );
			transform.eulerAngles = lastMouse;
			lastMouse = Input.mousePosition;
		}

		var f = 0.0f;
		var p = GetBaseInput ( );
		if ( Input.GetKey ( KeyCode.LeftShift ) )
		{
			totalRun += Time.deltaTime;
			p = p * totalRun * shiftAdd;
			p.x = Mathf.Clamp ( p.x, -maxShift, maxShift );
			p.y = Mathf.Clamp ( p.y, -maxShift, maxShift );
			p.z = Mathf.Clamp ( p.z, -maxShift, maxShift );
		}
		else
		{
			totalRun = Mathf.Clamp ( totalRun * 0.5f, 1f, 1000f );
			p = p * mainSpeed;
		}

		p = p * Time.deltaTime;
		var newPosition = transform.position;
		if ( Input.GetKey ( KeyCode.Space )
			|| ( movementStaysFlat && !( rotateOnlyIfMousedown && Input.GetMouseButton ( 1 ) ) ) )
		{ 
			transform.Translate ( p );
			newPosition.x = transform.position.x;
			newPosition.z = transform.position.z;
			transform.position = newPosition;
		}
		else
		{
			transform.Translate ( p );
		}

	}

	private Vector3 p_Velocity;
	private Vector3 GetBaseInput ( )
	{
		var smoothing = Time.smoothDeltaTime;

		p_Velocity = Vector3.Lerp (p_Velocity, Vector3.zero, smoothing);
		p_Velocity = Vector3.MoveTowards (p_Velocity, Vector3.zero, smoothing);

		if ( Input.GetKey ( KeyCode.W ) )
		{
			p_Velocity = Vector3.Lerp ( p_Velocity, p_Velocity += new Vector3 ( 0, 0, 1 ), smoothing * 3f);
			p_Velocity = Vector3.MoveTowards ( p_Velocity, p_Velocity += new Vector3 ( 0, 0, 1 ), smoothing * 3f);
		}
		if ( Input.GetKey ( KeyCode.S ) )
		{
			p_Velocity = Vector3.Lerp ( p_Velocity, p_Velocity += new Vector3 ( 0, 0, -1 ), smoothing * 3f );
			p_Velocity = Vector3.MoveTowards ( p_Velocity, p_Velocity += new Vector3 ( 0, 0, -1 ), smoothing * 3f);
		}
		if ( Input.GetKey ( KeyCode.A ) )
		{
			p_Velocity = Vector3.Lerp ( p_Velocity, p_Velocity += new Vector3 ( -1, 0, 0 ), smoothing *3f );
			p_Velocity = Vector3.MoveTowards ( p_Velocity, p_Velocity += new Vector3 ( -1, 0, 0 ), smoothing * 3f);
		}
		if ( Input.GetKey ( KeyCode.D ) )
		{
			p_Velocity = Vector3.Lerp ( p_Velocity, p_Velocity += new Vector3 ( 1, 0, 0 ), smoothing * 3f );
			p_Velocity = Vector3.MoveTowards ( p_Velocity, p_Velocity += new Vector3 ( 1, 0, 0 ), smoothing *3f );
		}

		return p_Velocity;
	}
}